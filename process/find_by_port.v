module process

const (
	err_not_found = error('The port is available:')
)

struct Process {
pub:
	proto string
	addr  string
	pid   int
}
