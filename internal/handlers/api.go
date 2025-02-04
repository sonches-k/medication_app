package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sonches-k/medication_app/internal/models"
)

type userId struct {
	userId int `json:"userId"`
}

type drugId struct {
	drugId int `json:"drugId"`
}

func (handler *Handler) GetUsers(context *gin.Context) {
	var input userId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	users, err := handler.services.GetUsers()
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, users)
}
func (handler *Handler) GetUserById(context *gin.Context) {
	var input userId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	user, err := handler.services.GetUserById(input.userId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, user)
}
func (handler *Handler) GetUserDrugs(context *gin.Context) {
	var input userId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	drugs, err := handler.services.GetUserDrugs(input.userId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, drugs)
}

func (handler *Handler) GetDrugCourse(context *gin.Context) {
	var input drugId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	course, err := handler.services.GetDrugCourse(input.drugId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, course)
}

func (handler *Handler) DeleteUser(context *gin.Context) {
	var input userId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	err := handler.services.DeleteUser(input.userId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, "User deleted")
}

type UserDrugInput struct {
	drug   models.Drug `json:"drug"`
	userId int         `json:"userId"`
}

func (handler *Handler) AddUserDrug(context *gin.Context) {
	var input UserDrugInput
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	err := handler.services.AddUserDrug(input.drug, input.userId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, "Drug added")
}

func (handler *Handler) DeleteUserDrug(context *gin.Context) {
	var input drugId
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	err := handler.services.DeleteUserDrug(input.drugId)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, "Drug deleted")
}

func (handler *Handler) EditCourse(context *gin.Context) {
	var input models.Course
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	err := handler.services.EditCourse(input)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, "Course edited")
}
