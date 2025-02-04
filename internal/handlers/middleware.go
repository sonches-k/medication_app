package handlers

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

const (
	authorizationHeader = "Authorization"
	userCtx             = "userId"
)

func (handler *Handler) userIndentity(context *gin.Context) {
	header := context.GetHeader(authorizationHeader)
	if header == "" {
		newErrorResponse(context, http.StatusUnauthorized, "empty auth header")
		return
	}
	headerParts := strings.Split(header, " ")
	if len(headerParts) != 2 {
		newErrorResponse(context, http.StatusUnauthorized, "invalid auth header")
		return
	}
	userId, err := handler.services.Authorization.ParseToken(headerParts[1])
	if err != nil {
		newErrorResponse(context, http.StatusUnauthorized, err.Error())
	}
	context.Set(userCtx, userId)

}
