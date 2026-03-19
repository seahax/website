package validate

import (
	"fmt"
	"regexp"
)

var dbNamePattern = regexp.MustCompile(`^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$`)

// Validate a database name. Can only contain lowercase letters, numbers, and
// hyphens. Must start with a letter and cannot end with a hyphen.
func DatabaseName(name string) error {
	if !dbNamePattern.MatchString(name) {
		return fmt.Errorf("invalid database name %q", name)
	}

	return nil
}
