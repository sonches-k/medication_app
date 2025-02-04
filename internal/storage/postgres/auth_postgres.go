package postgres

import (
	"context"
	"errors"

	"github.com/sonches-k/medication_app/internal/models"
)

type AuthPostgres struct {
	db *PGRepo
}

func NewAuthPostgres(db *PGRepo) *AuthPostgres {
	return &AuthPostgres{db: db}
}

func (s *AuthPostgres) CreateUser(user models.User) (int, error) {
	var id int
	row, err := s.db.pool.Query(context.Background(), "INSERT INTO users (name, password_hash, email) VALUES ($1, $2, $3) RETURNING id;", user.Name, user.PasswordHash, user.Email)
	if err != nil {
		return 0, err
	}
	defer row.Conn()
	if row.Next() {
		if err := row.Scan(&id); err != nil {
			return 0, err
		}
	} else {
		return 0, errors.New("rows bug")
	}
	return id, nil
}

func (s *AuthPostgres) GetUserByEmailAndPassword(email, password string) (*models.User, error) {
	rows, err := s.db.pool.Query(context.Background(), "SELECT id, name, password_hash, email, drugs FROM users;")
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
			&item.Drugs,
		)
		if err != nil {
			return nil, err
		}
		if item.Email == email && item.PasswordHash == password {
			data = append(data, item)
		}
	}
	if len(data) == 0 {
		return nil, errors.New("user not found")
	}
	return &data[0], nil
}
