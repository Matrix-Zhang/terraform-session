package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestAlbExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../examples/alb/",
	}

	defer terraform.Destroy(t, opts)

	terraform.InitAndApply(t, opts)
	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	exceptedStatus := 404
	exceptedBody := "404; not found"
	maxRetries := 10
	timeBetweenRetries := time.Second * 10

	http_helper.HttpGetWithRetry(t, url, nil, exceptedStatus, exceptedBody, maxRetries, timeBetweenRetries)
}
