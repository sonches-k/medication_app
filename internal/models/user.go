package models

type User struct {
	Id           int    `json:"id" `
	Name         string `json:"name"`
	PasswordHash string `json:"password" `
	Email        string `json:"email"`
	Drugs        []Drug `json:"drugs"`
}
