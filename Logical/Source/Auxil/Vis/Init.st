

PROGRAM _INIT
	FOR idx := 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		Vis.Shuttles[idx].ID := idx+1;
		Vis.Shuttles[idx].ScnViewer.PathLength := 35;
	END_FOR;
	
	Vis.Shuttles[0].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[0].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[0].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[1].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[1].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[1].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[2].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[2].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[2].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[3].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[3].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[3].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[4].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[4].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[4].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[5].ScnViewer.PathColor[0] := 0.75;
	Vis.Shuttles[5].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[5].ScnViewer.PathColor[2] := 0.75;
	
	Vis.Shuttles[6].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[6].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[6].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[7].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[7].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[7].ScnViewer.PathColor[2] := 0.5;
	turnOnAllPaths := TRUE;
END_PROGRAM