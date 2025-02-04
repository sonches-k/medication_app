package postgres

import (
	"context"
	"sync"

	"github.com/jackc/pgx/v5/pgxpool"
)

type PGRepo struct {
	mutex sync.Mutex
	pool  *pgxpool.Pool
}

func NewPostgresConn(connUrl string) (*PGRepo, error) {

	pool, err := pgxpool.New(context.Background(), connUrl)
	if err != nil {
		return nil, err
	}
	return &PGRepo{mutex: sync.Mutex{}, pool: pool}, nil
}
