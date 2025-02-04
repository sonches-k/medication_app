package main

import (
	"context"
	"fmt"
	"sync"

	"github.com/sirupsen/logrus"
	"github.com/sonches-k/medication_app/internal"
	"github.com/sonches-k/medication_app/internal/handlers"
	"github.com/sonches-k/medication_app/internal/services"
	"github.com/sonches-k/medication_app/internal/storage"
	"github.com/sonches-k/medication_app/internal/storage/postgres"
	"github.com/spf13/viper"
)

func main() {
	logrus.SetFormatter(new(logrus.JSONFormatter))
	if err := initConfig(); err != nil {
		logrus.Fatalf("error initializing configs: %s", err.Error())
	}
	db, err := postgres.NewPostgresConn(viper.GetString("url"))
	if err != nil {
		logrus.Fatalf("failed to initialize db:%s", err.Error())
	}
	storage := storage.NewStorage(db)
	services := services.NewService(storage)
	handlers := handlers.NewHandler(services)

	srv := new(internal.Server)
	var str string
	var wg sync.WaitGroup

	for {
		fmt.Scan(&str)
		if str == "stop" {
			err := srv.Shutdown(context.Background())
			if err != nil {
				logrus.Error("cannot shutdown server")
			}
		}
		if str == "run" {
			wg.Add(1)
			go func() {
				defer wg.Done()
				if err := srv.Run(viper.GetString("port"), handlers.InitRoutes()); err != nil {
					logrus.Fatalf("error occured while running http server: %s", err.Error())
				}
			}()
			wg.Wait()
		}
	}

}

func initConfig() error {
	viper.AddConfigPath("configs")
	viper.SetConfigName("config")
	return viper.ReadInConfig()
}
