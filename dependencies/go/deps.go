package dependencygraph

import (
	"github.com/gin-gonic/gin"
	"github.com/spf13/cobra"
)

// Keep the direct module requirements reachable so `go mod tidy` retains them.
var (
	_ = gin.Version
	_ = cobra.Command{}
)
