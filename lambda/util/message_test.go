package util_test

import (
	"containerlambda/util"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func Test_NewMessage(t *testing.T) {
	cases := []struct {
		name   string
		tm     time.Time
		expect string
	}{}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			asst := assert.New(t)

			msg := util.NewMessage(c.tm)

			asst.Equal(c.expect, msg)
		})
	}
}
