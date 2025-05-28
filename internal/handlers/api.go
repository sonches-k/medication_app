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

// @Summary Получить всех пользователей
// @Tags users
// @Produce json
// @Success 200 {array} models.User
// @Failure 500 {object} handlers.errorResponse
// @Router /users [get]
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

// @Summary Получить пользователя по ID
// @Tags users
// @Produce json
// @Param userid path int true "ID пользователя"
// @Success 200 {object} models.User
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid} [get]
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

// @Summary Получить препараты пользователя
// @Tags users
// @Produce json
// @Param userid path int true "ID пользователя"
// @Success 200 {array} models.Drug
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid}/drugs [get]
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

// @Summary Получить курс по препарату
// @Tags users
// @Produce json
// @Param userid path int true "ID пользователя"
// @Param drugid path int true "ID препарата"
// @Success 200 {object} models.Course
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid}/drugs/{drugid}/course [get]
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

// @Summary Удалить пользователя
// @Tags users
// @Produce json
// @Param userid path int true "ID пользователя"
// @Success 200 {string} string "User deleted"
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid} [delete]
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

// @Summary Добавить препарат пользователю
// @Tags users
// @Accept json
// @Produce json
// @Param userid path int true "ID пользователя"
// @Param drugid path int true "ID препарата"
// @Param input body models.Drug true "Информация о препарате"
// @Success 200 {string} string "Drug added"
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid}/{drugid} [post]
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

// @Summary Удалить препарат пользователя
// @Tags users
// @Produce json
// @Param userid path int true "ID пользователя"
// @Param drugid path int true "ID препарата"
// @Success 200 {string} string "Drug deleted"
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid}/drugs/{drugid} [delete]
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

// @Summary Редактировать курс препарата
// @Tags users
// @Accept json
// @Produce json
// @Param userid path int true "ID пользователя"
// @Param drugid path int true "ID препарата"
// @Param input body models.Course true "Новый курс"
// @Success 200 {string} string "Course edited"
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /users/{userid}/drugs/{drugid}/course [patch]
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

// @Summary Получить препарат по названию
// @Tags info
// @Produce json
// @Param name path string true "Название препарата"
// @Success 200 {object} models.Drug
// @Failure 400 {object} handlers.errorResponse
// @Failure 500 {object} handlers.errorResponse
// @Router /info/drug/{name} [get]
func (h *Handler) GetDrugByName(context *gin.Context) {
	var input string
	if err := context.BindJSON(&input); err != nil {
		newErrorResponse(context, http.StatusBadRequest, err.Error())
		return
	}
	drug, err := h.services.GetDrugByName(input)
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, drug)
}

// @Summary Получить все препараты
// @Tags info
// @Produce json
// @Success 200 {array} models.Drug
// @Failure 500 {object} handlers.errorResponse
// @Router /info/drug [get]
func (h *Handler) GetDrugs(context *gin.Context) {
	drugs, err := h.services.GetDrugs()
	if err != nil {
		newErrorResponse(context, http.StatusInternalServerError, err.Error())
		return
	}
	context.JSON(http.StatusOK, drugs)
}
