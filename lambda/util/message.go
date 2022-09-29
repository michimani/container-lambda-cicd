package util

import (
	"fmt"
	"time"
)

const message = "Hello Container Lambda!!"

func NewMessage(t time.Time) string {
	return fmt.Sprintf("[%s] %s", time.Now().Format(time.RFC3339), message)
}
