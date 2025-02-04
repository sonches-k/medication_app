package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/sonches-k/medication_app/internal/services"
)

type Handler struct {
	services *services.Service
}

func NewHandler(services *services.Service) *Handler {
	return &Handler{services: services}
}
func (handler *Handler) InitRoutes() *gin.Engine {
	router := gin.New()
	auth := router.Group("/auth")
	{
		auth.POST("/signup", handler.singUp)
		auth.POST("/signin", handler.singIn)
	}
	api := router.Group("/users", handler.userIndentity)
	{
		api.GET("", handler.GetUsers)
		api.GET(":userid", handler.GetUserById)
		api.GET(":userid/drugs", handler.GetUserDrugs)
		api.POST(":userid/:drugid", handler.AddUserDrug)
		api.GET(":userid/drugs/:drugid/course", handler.GetDrugCourse)
		api.PATCH(":userid/drugs/:drugid/course", handler.EditCourse)
		api.DELETE(":userid", handler.DeleteUser)
		api.DELETE(":userid/drugs/:drugid", handler.DeleteUserDrug)
	}
	return router
}
