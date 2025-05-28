package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

const (
	accessHeader  = "access"
	refreshHeader = "refresh"
	userCtx       = "userId"
)

func (handler *Handler) userIndentity(context *gin.Context) {
	accessHeader := context.GetHeader(accessHeader)
	if accessHeader == "" {
		newErrorResponse(context, http.StatusUnauthorized, "empty auth header")
		return
	}
	refreshHeader := context.GetHeader(refreshHeader)
	if refreshHeader == "" {
		newErrorResponse(context, http.StatusUnauthorized, "empty auth header")
		return
	}
	userId, err := handler.services.Authorization.ParseToken(accessHeader)
	if err != nil {
		userId, err = handler.services.Authorization.ParseToken(refreshHeader)
		if err != nil {
			newErrorResponse(context, http.StatusUnauthorized, err.Error())
		}
	}
	context.Set(userCtx, userId)

}
