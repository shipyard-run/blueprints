package vault

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
)

type Client struct {
	addr  string
	token string
}

type EncryptRequest struct {
	Plaintext string `json:"plaintext"`
}

type EncryptResponse struct {
	Data EncryptReponseData `json:"data"`
}

type EncryptReponseData struct {
	CipherText string `json:"ciphertext"`
}

// NewClient creates a new Vault client
func NewClient(addr, token string) *Client {
	return &Client{addr, token}
}

// IsOK returns true if Vault is unsealed and can accept requests
func (c *Client) IsOK() bool {
	url := fmt.Sprintf("%s/v1/sys/health", c.addr)

	r, _ := http.NewRequest(http.MethodGet, url, nil)
	//r.Header.Add("X-Vault-Token", "root")

	resp, err := http.DefaultClient.Do(r)
	if err != nil {
		return false
	}

	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return false
	}

	return true
}

// EncryptData uses the Vault API to encrypt the given string
func (c *Client) EncryptData(cc string) (string, error) {
	url := fmt.Sprintf("%s/v1/transit/encrypt/web", c.addr)

	// base64 encode
	base64cc := base64.StdEncoding.EncodeToString([]byte(cc))

	data, _ := json.Marshal(EncryptRequest{Plaintext: base64cc})
	r, _ := http.NewRequest(http.MethodPost, url, bytes.NewReader(data))
	r.Header.Add("X-Vault-Token", c.token)

	resp, err := http.DefaultClient.Do(r)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("Vault returned reponse code %d, expected status code 200", resp.StatusCode)
	}

	tr := &EncryptResponse{}
	err = json.NewDecoder(resp.Body).Decode(tr)
	if err != nil {
		return "", err
	}

	return tr.Data.CipherText, nil
}
