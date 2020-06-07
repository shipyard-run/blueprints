package handlers

import (
	"net/http"

	"github.com/docker/go/canonical/json"
	"github.com/hashicorp/app/vault"
	"github.com/hashicorp/go-hclog"
)

type Pay struct {
	vaultClient *vault.Client
	log         hclog.Logger
}

func NewPay(vc *vault.Client, l hclog.Logger) *Pay {
	return &Pay{vc, l}
}

type PayRequest struct {
	CardNumber string `json:"card_number"`
}

type PayResponse struct {
	CipherText string `json:"ciphertext"`
}

func (p *Pay) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	p.log.Info("Handle Pay")

	pr := &PayRequest{}
	defer r.Body.Close()

	err := json.NewDecoder(r.Body).Decode(pr)
	if err != nil {
		p.log.Error("Unable to decode body", "error", err)
		rw.WriteHeader(http.StatusBadRequest)
		return
	}

	// encode the request credit card number
	d, err := p.vaultClient.EncryptData(pr.CardNumber)
	if err != nil {
		p.log.Error("Unable to encrypt data", "error", err)
		rw.WriteHeader(http.StatusInternalServerError)
		return
	}

	// write the response
	json.NewEncoder(rw).Encode(
		PayResponse{
			CipherText: d,
		},
	)
}
