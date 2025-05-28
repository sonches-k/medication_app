package postgres

import (
	"context"
	"errors"

	"github.com/sonches-k/medication_app/internal/models"
)

type ApiPostgres struct {
	db *PGRepo
}

func NewApiPostgres(db *PGRepo) *ApiPostgres {
	return &ApiPostgres{db: db}
}

func (s *ApiPostgres) GetUsers() ([]models.User, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id, name, password_hash, email, phone FROM users;")
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.User
	for rows.Next() {
		var item models.User
		err := rows.Scan(
			&item.Id,
			&item.Name,
			&item.PasswordHash,
			&item.Email,
			&item.Phone,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	return data, nil
}
func (s *ApiPostgres) GetUserById(id int) (*models.User, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id, name, password_hash, email, phone FROM users WHERE id=$1;", id)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.User
	for rows.Next() {
		var item models.User
		err := rows.Scan(
			&item.Id,
			&item.Name,
			&item.PasswordHash,
			&item.Email,
			&item.Phone,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	if len(data) == 0 {
		return nil, errors.New("user not found")
	}
	return &data[0], nil
}

// TODO
func (s *ApiPostgres) GetUserDrugs(id int) ([]models.Drug, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT drug_id FROM user_drugs WHERE user_id=$1;", id)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []int
	for rows.Next() {
		var item int
		err := rows.Scan(
			&item,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	var resp []models.Drug
	for _, id := range data {
		drug, err := s.GetDrugById(id)
		if err != nil {
			return nil, err
		}
		resp = append(resp, *drug)
	}
	return resp, nil
}

func (s *ApiPostgres) GetDrugById(id int) (*models.Drug, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id,name,price,expiration_date FROM drugs WHERE id=$1;", id)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.Drug
	for rows.Next() {
		var item models.Drug
		err := rows.Scan(
			&item.Id,
			&item.Name,
			&item.Price,
			&item.ExpirationDate,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	if len(data) == 0 {
		return nil, errors.New("drug not found")
	}
	return &data[0], nil
}

func (s *ApiPostgres) GetDrugByUserId(userId int) ([]models.Drug, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT drug_id FROM user_drugs WHERE user_id=$1;", userId)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.Drug
	for rows.Next() {
		var item models.Drug
		err := rows.Scan(
			&item.Id,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	if len(data) == 0 {
		return nil, errors.New("drug not found")
	}
	return data, nil
}

func (s *ApiPostgres) GetDrugCourse(id int) (*models.Course, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id FROM drug_courses WHERE drug_id=$1;", id)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.Course
	for rows.Next() {
		var item models.Course
		err := rows.Scan(
			&item.Id,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	if len(data) == 0 {
		return nil, errors.New("course not found")
	}
	return &data[0], nil
}
func (s *ApiPostgres) DeleteUser(id int) error {
	_, err := s.db.pool.Exec(context.Background(), "DELETE FROM users WHERE id=$1;", id)
	return err
}
func (s *ApiPostgres) DeleteUserDrug(id int) error {
	_, err := s.db.pool.Exec(context.Background(), "DELETE FROM drugs WHERE id=$1;", id)
	return err
}
func (s *ApiPostgres) AddUserDrug(drug models.Drug, userId int) error {
	_, err := s.db.pool.Exec(context.Background(), "INSERT INTO drugs (name, user_id) VALUES ($1, $2);", drug.Name, userId)
	return err
}
func (s *ApiPostgres) EditCourse(course models.Course) error {
	_, err := s.db.pool.Exec(context.Background(), "UPDATE drug_courses SET course=$1 WHERE id=$2;", course.Duration, course.Id)
	return err
}
func (s *ApiPostgres) GetDrugByName(name string) (*models.Drug, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id, name, price, expiration_date FROM drugs WHERE name=$1;", name)
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.Drug
	for rows.Next() {
		var item models.Drug
		err := rows.Scan(
			&item.Id,
			&item.Name,
			&item.Price,
			&item.ExpirationDate,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	if len(data) == 0 {
		return nil, errors.New("drug not found")
	}
	return &data[0], nil
}
func (s *ApiPostgres) GetDrugs() ([]models.Drug, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id, name, price, expiration_date FROM drugs;")
	if err != nil {
		return nil, err
	}
	defer rows.Conn()
	var data []models.Drug
	for rows.Next() {
		var item models.Drug
		err := rows.Scan(
			&item.Id,
			&item.Name,
			&item.Price,
			&item.ExpirationDate,
		)
		if err != nil {
			return nil, err
		}
		data = append(data, item)
	}
	return data, nil
}
