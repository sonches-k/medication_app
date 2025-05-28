package services

import (
	"crypto/sha1"
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/sonches-k/medication_app/internal/models"
	"github.com/sonches-k/medication_app/internal/storage"
)

const (
	salt       = "sklf12kdkfks21kmafzzxcifds"
	signingKey = "lasdjqi8932jkdn#aqwxcvn1wxcllkas"
)

type AuthService struct {
	repo storage.Authorization
}
type tokenCLaims struct {
	jwt.StandardClaims
	UserId int `json:"user_id"`
}

func NewAuthService(repo storage.Authorization) *AuthService {
	return &AuthService{repo: repo}
}
func (service *AuthService) GenerateToken(username, password string, tokenTTL time.Duration) (string, error) {
	user, err := service.repo.GetUserByEmailAndPassword(username, generatePasswrodHash(password))
	if err != nil {
		return "", err
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &tokenCLaims{
		UserId: user.Id,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(tokenTTL).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	})
	return token.SignedString([]byte(signingKey))
}

func (service *AuthService) ParseToken(acessToken string) (int, error) {
	token, err := jwt.ParseWithClaims(acessToken, &tokenCLaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("invalid signing method")
		}

		return []byte(signingKey), nil
	})
	if err != nil {
		return 0, err
	}
	claims, ok := token.Claims.(*tokenCLaims)
	if !ok {
		return 0, errors.New("token claims are not of type *tokenClaims")
	}
	return claims.UserId, nil
}
func (service *AuthService) CreateUser(user models.User) (int, error) {
	user.PasswordHash = generatePasswrodHash(user.PasswordHash)

	return service.repo.CreateUser(user)
}

func generatePasswrodHash(password string) string {
	hash := sha1.New()
	hash.Write([]byte(password))
	return fmt.Sprintf("%x", hash.Sum([]byte(salt)))
}
