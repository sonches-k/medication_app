package models

type Drug struct {
	Id             int     `json:"id"`
	Name           string  `json:"name"`
	Price          float64 `json:"price"`
	ExpirationDate string  `json:"expiration_date"`
}
