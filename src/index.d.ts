interface ConstrainedMarkersDefaults {
    /**
     * @description Sets the width and height of the marker’s BodyGUI. The Scale component is applied to both axes, and is based on the boundary GUI’s shortest axis.
     * @default new UDim(0.05, 0)
     */
    Size?: UDim;

    /**
     * @description Sets the color of the marker.
     * @default Color3.fromRGB(242, 72, 72)
     */
    Color?: Color3;

    /**
     * @description Sets the transparency of the marker.
     * @default 0
     */
    Transparency?: number;

    /**
     * @description Sets an image to be displayed on the marker.
     * @default No image.
     */
    Icon?: string;

    /**
     * @description Sets the sprite offset and size of the icon.
     * @default new Rect(0, 0, 0, 0)
     */
    IconRect?: Rect;

    /**
     * @description Sets the color of the icon.
     * @default Color3.fromRGB(255, 255, 255)
     */
    IconColor3?: Color3;
}

/**
 * @description A table that holds the marker’s state.
 */
interface MarkerState {
    /**
     * @description The position being targeted by the marker.
     * @default undefined
     */
    Target?: Vector3 | CFrame | BasePart | Attachment | Model | Camera;

    /**
     * @description Used as the body of the marker GUI. The GUI will have its Position property modified. It may also have its Transparency and Visible properties modified in some cases. The GUI is parented to the boundary GUI, and parented to nil if the marker is removed.
     */
    BodyGUI: GuiObject;

    /**
     * @description Used as the arrow of the marker GUI. The GUI will have its Rotation and Visible properties modified, and will be visible only if arrows are enabled. The GUI is parented to the body GUI, and parented to nil if the marker is removed. Note that a Rotation of 0 should have the arrow pointing in the positive X direction.
     */
    ArrowGUI: GuiObject;

    /**
     * @description Sets whether this marker’s arrow is visible. When nil, the visibility is determined by SetArrowsEnabled.
     * @default undefined
     */
    ArrowEnabled?: boolean;
}

type ConstraintType = ("Constrained" | "Hidden" | "Unconstrained");
type BoundaryType = ("Rectangle" | "Circle" | "Ellipse" | "TruncatedCircle");
type SetBoundaryArguments<T = BoundaryType> = (
    T extends "Rectangle" ? string :
    T extends "TruncatedCircle" ? string :
    undefined
);


declare interface ConstrainedMarkers {
    /**
     * @description Returns the boundary GUI.
     * @returns The boundary GUI.
     */
    BoundaryGUI(this: ConstrainedMarkers): GuiObject;


    /**
     * @description Sets the shape of the boundary. Extra arguments depend on the type.
     * @param boundaryType {BoundaryType} See https://devforum.roblox.com/t/constrainedmarkers-module/67640
     * @default "Rectangle"
     */
    SetBoundaryType<T extends BoundaryType>(this: ConstrainedMarkers, boundaryType: T, args?: SetBoundaryArguments<T>): void;


    /**
     * @description Sets whether markers will be displayed and updated.
     * When disabled, the boundary GUI will be made invisible, and the update cycle
     * will not be active. Consequentially, the container can be safely garbage
     * collected.
     * @param enabled {boolean} Whether the container is enabled.
     */
    SetEnabled(this: ConstrainedMarkers, enabled: boolean): void;


    /**
     * @description Specifies the behavior of markers outside the boundary.
     * @param constraintType {ConstraintType}
     * @default "Constrained"
     */
    SetConstraintType(this: ConstrainedMarkers, constraintType: ConstraintType): void;


    /**
     * @description Sets whether a marker will display an arrow pointing to its target when the marker is constrained. Note that this state can be overwritten per marker with the marker’s ArrowEnabled field.
     * @param enabled {boolean} Whether arrows are enabled.
     * @default true
     */
    SetArrowsEnabled(this: ConstrainedMarkers, enabled: boolean): void;


    /**
     * @description Sets the origin from which marker positions are determined. Marker target positions are projected onto a Camera’s 2D plane.
     * @param origin {Camera | undefined} Uses the Camera’s CFrame or uses the value of Workspace.CurrentCamera. Note that this updates when the CurrentCamera changes.
     */
    SetOrigin(this: ConstrainedMarkers, origin?: Camera): void;


    /**
     * @description Creates a new marker from an initial state.
     * @param initialState {Partial<MarkerState>} Each recognized field in the initial state sets the value of the corresponding field the marker state. If an initial value is nil, then the field will be set to a default instead.
     * @returns A table that holds the marker’s state.
     */
    CreateMarker(this: ConstrainedMarkers, initialState?: Partial<MarkerState>): MarkerState;


    /**
     * @description Returns a list of all the marker states in the container. Note that the order is undefined.
     * @returns A list of marker states.
     */
    Markers(this: ConstrainedMarkers): MarkerState[];


    /**
     * @description Removes one or more markers from the container. Changes made to each marker’s state will no longer be recognized, and the marker will no longer be valid for the container.
     * @throws An error if any value is not a known marker state.
     */
    RemoveMarker(this: ConstrainedMarkers, ...markers: MarkerState[]): void;


    /**
     * @description Removes all markers from the container.
     */
    RemoveAllMarkers(this: ConstrainedMarkers): void;


    /**
     * @description Reevaluates a marker state, forcing all changes made to the state to be recognized. Also checks if all values in the state are valid.
     */
    UpdateMarker(this: ConstrainedMarkers, ...markers: MarkerState[]): void;
}
interface ConstrainedMarkersConstructor {
    /**
     * @description Create a new container for constrained markers.
     * @param boundary {GuiObject} Used as the parent of marker GUIs. The limits of the boundary depends on the size of the GUI. Note that, since only the position of a marker is constrained, the marker’s body may still appear slightly outside the boundary.
     * @param enabled {boolean} Sets whether the container will be enabled immediately, before being returned by New.
     * @param defaults {ConstrainedMarkersDefaults} If specified, configures the appearance of the default marker template.
     */
     New: (boundary?: GuiObject, enabled?: boolean, defaults?: ConstrainedMarkersDefaults) => ConstrainedMarkers;
}

declare const ConstrainedMarkersExport: ConstrainedMarkersConstructor;
export = ConstrainedMarkersExport;