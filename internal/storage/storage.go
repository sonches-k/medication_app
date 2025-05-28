package storage

import (
	"github.com/sonches-k/medication_app/internal/models"
	"github.com/sonches-k/medication_app/internal/storage/postgres"
)

type Authorization interface {
	CreateUser(user models.User) (int, error)
	GetUserByEmailAndPassword(username, password string) (*models.User, error)
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

type Storage struct {
	Api
	Authorization
}

func NewStorage(repos *postgres.PGRepo) *Storage {
	return &Storage{
		Authorization: postgres.NewAuthPostgres(repos),
		Api:           postgres.NewApiPostgres(repos),
	}
}
