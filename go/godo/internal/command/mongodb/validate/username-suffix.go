package validate

import (
	"fmt"
	"regexp"
)

var usernameSuffixPatter = regexp.MustCompile(`^[a-z0-9]+(?:-[a-z0-9]+)*$`)

// Validate a username suffix. Can only contain lowercase letters, numbers, and
// hyphens. Cannot start or end with a hyphen.
func UsernameSuffix(suffix string) error {
	if !usernameSuffixPatter.MatchString(suffix) {
		return fmt.Errorf("invalid username suffix %q", suffix)
	}

	return nil
}
