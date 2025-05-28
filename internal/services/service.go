package services

import (
	"time"

	"github.com/sonches-k/medication_app/internal/models"
	"github.com/sonches-k/medication_app/internal/storage"
)

type Authorization interface {
	CreateUser(user models.User) (int, error)
	GenerateToken(email, password string, tokenTTl time.Duration) (string, error)
	ParseToken(token string) (int, error)
}
type Api interface {
	GetUsers() ([]models.User, error)
	GetUserById(id int) (*models.User, error)
	GetUserDrugs(id int) ([]models.Drug, error)
	GetDrugCourse(id int) (*models.Course, error)
	DeleteUser(id int) error
	DeleteUserDrug(id int) error
	AddUserDrug(drug models.Drug, id int) error
	EditCourse(course models.Course) error
	GetDrugByName(name string) (*models.Drug, error)
	GetDrugs() ([]models.Drug, error)
}

type Service struct {
	Api
	Authorization
}

func NewService(repos *storage.Storage) *Service {
	return &Service{
		Authorization: NewAuthService(repos.Authorization),
		Api:           NewApiService(repos.Api),
	}
}
