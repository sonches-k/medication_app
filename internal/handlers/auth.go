package handlers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/sonches-k/medication_app/internal/models"
)

const (
	accessTokenTTL  = 15 * time.Minute
	refreshTokenTTL = 30 * time.Hour
)

// @Summary register user
// @Description Register user and returns id
// @Tags auth
// @Accept  json
// @Produce  json
// @Param   credentials body models.User true "User credentials"
// @Success 200 {object} int
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /auth/signup [post]
func (h *Handler) singUp(context *gin.Context) {
	var input models.User
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	id, err := h.services.Authorization.CreateUser(input)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, map[string]interface{}{
		"id": id,
	})
}

type signInInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}
type StringMap map[string]string

// @Summary Login user
// @Description Authenticates user and returns token
// @Tags auth
// @Accept  json
// @Produce  json
// @Param   credentials body models.User true "User credentials"
// @Success 200 {object} StringMap
// @Failure 401 {object} handlers.errorResponse
// @Router /auth/signin [post]
func (h *Handler) singIn(context *gin.Context) {
	var input signInInput
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	refreshToken, err := h.services.Authorization.GenerateToken(input.Email, input.Password, refreshTokenTTL)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	accessToken, err := h.services.Authorization.GenerateToken(input.Email, input.Password, accessTokenTTL)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, map[string]interface{}{
		"access_token":  accessToken,
		"refresh_token": refreshToken,
	})
}
