package main

import (
	"io/ioutil"
	"net/http"
	"os"
	"time"

	"github.com/hashicorp/app/data"
	"github.com/hashicorp/app/handlers"
	"github.com/hashicorp/app/vault"
	"github.com/hashicorp/go-hclog"
	"github.com/nicholasjackson/config"
	"github.com/nicholasjackson/env"
)

// Config defines a structure which holds individual configuration parameters for the application
type Config struct {
	DBConnection   string `json:"db_connection"`
	BindAddress    string `json:"bind_address"`
	TLSCertFile    string `json:"tls_cert_file"`
	TLSKeyFile     string `json:"tls_key_file"`
	VaultAddr      string `json:"vault_addr"`
	VaultTokenFile string `json:"vault_token_file"`
	PaymentsAPIKey string `json:"payments_api_key"`
}

var conf *Config
var configFile = env.String("CONFIG_FILE", false, "./config.json", "Path to JSON encoded config file")

func main() {
	env.Parse()

	log := hclog.Default()

	conf = &Config{}

	// Create a new config watcher
	c, err := config.New(
		*configFile,
		conf,
		log.StandardLogger(&hclog.StandardLoggerOptions{}),
		func() {
			log.Info("Config file updated", "config", conf)
		},
	)
	defer c.Close()

	// load the Vault token
	d, err := ioutil.ReadFile(conf.VaultTokenFile)
	if err != nil {
		log.Error("Unable to read Vault token", "error", err)
	}

	// Create the vault client
	vc := vault.NewClient(conf.VaultAddr, string(d))
	if !vc.IsOK() {
		log.Error("Unable to connect to Vault server")
		os.Exit(1)
	}

	// Create the database connection
	db, err := data.New(conf.DBConnection, 60*time.Second)
	if err != nil {
		log.Error("Unable to connect to database", "error", err)
		os.Exit(1)
	}

	// Create the product handler
	hc := handlers.NewCoffee(db, log)
	hp := handlers.NewPay(vc, log)

	http.Handle("/", hc)
	http.Handle("/pay", hp)

	log.Info("Starting Server", "bind", conf.BindAddress)

	// If TLS is configured start the server
	if conf.TLSCertFile != "" && conf.TLSKeyFile != "" {
		err := http.ListenAndServeTLS(conf.BindAddress, conf.TLSCertFile, conf.TLSKeyFile, nil)
		if err != nil {
			log.Error("Unable to start server", "error", err)
		}
	} else {
		err := http.ListenAndServe(conf.BindAddress, nil)
		if err != nil {
			log.Error("Unable to start server", "error", err)
		}
	}
}
