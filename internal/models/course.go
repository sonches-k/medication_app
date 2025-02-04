package models

import "time"

type Course struct {
	Id       int           `json:"id"`
	Duration time.Duration `json:"duration"`
}
