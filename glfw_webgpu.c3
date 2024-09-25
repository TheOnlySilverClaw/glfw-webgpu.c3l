import glfw;
import webgpu;

def GlfwWindow = glfw::window::Window;

extern fn X11Display glfwGetX11Display();

extern fn X11Window glfwGetX11Window(GlfwWindow window);

extern fn WaylandDisplay glfwGetWaylandDisplay();

extern fn WaylandSurface glfwGetWaylandWindow(GlfwWindow window);


fn Surface createSurface(Instance instance, GlfwWindow window) {

	return createWaylandSurface(instance, window);
}

fn Surface createX11Surface(Instance instance, GlfwWindow window) {

	X11Display x11Display = glfwGetX11Display();
	X11Window x11Window = glfwGetX11Window(window);

	SurfaceDescriptorFromXlibWindow fromXlibWindow;
	fromXlibWindow.chain.next = null;
	fromXlibWindow.chain.sType = SType.SURFACE_DESCRIPTOR_FROM_XLIB_WINDOW;
	fromXlibWindow.display = x11Display;
	fromXlibWindow.window = x11Window;

	SurfaceDescriptor surfaceDescriptor;
	surfaceDescriptor.next = &fromXlibWindow.chain;
	surfaceDescriptor.label = null;

	return instance.createSurface(&surfaceDescriptor);
}

fn Surface createWaylandSurface(Instance instance, GlfwWindow window) {

	WaylandDisplay waylandDisplay = glfwGetWaylandDisplay();
	WaylandSurface waylandSurface = glfwGetWaylandWindow(window);

	SurfaceSourceWaylandSurface fromWaylandWindow;
	fromWaylandWindow.chain.next = null;
	fromWaylandWindow.chain.sType = SType.SURFACE_DESCRIPTOR_FROM_WAYLAND_SURFACE;
	fromWaylandWindow.display = waylandDisplay;
	fromWaylandWindow.surface = waylandSurface;

	SurfaceDescriptor surfaceDescriptor;
	surfaceDescriptor.next = &fromWaylandWindow.chain;
	surfaceDescriptor.label = null;

	return instance.createSurface(&surfaceDescriptor);
}
