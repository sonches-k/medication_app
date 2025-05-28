package services

import (
	"github.com/sonches-k/medication_app/internal/models"
	"github.com/sonches-k/medication_app/internal/storage"
)

type ApiService struct {
	repo storage.Api
}

func NewApiService(repo storage.Api) *ApiService {
	return &ApiService{repo: repo}
}

func (s *ApiService) GetUsers() ([]models.User, error) {
	return s.repo.GetUsers()
}
func (s *ApiService) GetUserById(id int) (*models.User, error) {
	return s.repo.GetUserById(id)
}
func (s *ApiService) GetUserDrugs(id int) ([]models.Drug, error) {
	return s.repo.GetUserDrugs(id)
}
func (s *ApiService) GetDrugCourse(id int) (*models.Course, error) {
	return s.repo.GetDrugCourse(id)
}
func (s *ApiService) DeleteUser(id int) error {
	return s.repo.DeleteUser(id)
}
func (s *ApiService) DeleteUserDrug(id int) error {
	return s.repo.DeleteUserDrug(id)
}
func (s *ApiService) AddUserDrug(drug models.Drug, id int) error {
	return s.repo.AddUserDrug(drug, id)
}
func (s *ApiService) EditCourse(course models.Course) error {
	return s.repo.EditCourse(course)
}
func (s *ApiService) GetDrugs() ([]models.Drug, error) {
	return s.repo.GetDrugs()
}
func (s *ApiService) GetDrugByName(name string) (*models.Drug, error) {
	return s.repo.GetDrugByName(name)
}
