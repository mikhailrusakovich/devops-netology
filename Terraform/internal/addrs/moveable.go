package addrs

// AbsMoveable is an interface implemented by address types that can be either
// the source or destination of a "moved" statement in configuration, along
// with any other similar cross-module state refactoring statements we might
// allow.
//
// Note that AbsMovable represents an absolute address relative to the root
// of the configuration, which is different than the direct representation
// of these in configuration where the author gives an address relative to
// the current module where the address is defined. The type MoveEndpoint
type AbsMoveable interface {
	absMoveableSigil()

	String() string
}

// The following are all of the possible AbsMovable address types:
var (
	_ AbsMoveable = AbsResource{}
	_ AbsMoveable = AbsResourceInstance{}
	_ AbsMoveable = ModuleInstance(nil)
	_ AbsMoveable = AbsModuleCall{}
)

// ConfigMoveable is similar to AbsMoveable but represents a static object in
// the configuration, rather than an instance of that object created by
// module expansion.
//
// Note that ConfigMovable represents an absolute address relative to the root
// of the configuration, which is different than the direct representation
// of these in configuration where the author gives an address relative to
// the current module where the address is defined. The type MoveEndpoint
// represents the relative form given directly in configuration.
type ConfigMoveable interface {
	configMoveableSigil()
}

// The following are all of the possible ConfigMovable address types:
var (
	_ ConfigMoveable = ConfigResource{}
	_ ConfigMoveable = Module(nil)
)
