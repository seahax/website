package create_user

type Opts struct {
	ClusterId string `flag:"<cluster>" help:"MongoDB database cluster ID" validate:"uuid"`
	Database  string `flag:"<database>" help:"MongoDB database name" validate:"required"`
	Suffix    string `flag:"<username-suffix>" help:"Username suffix" validate:"required"`
}
