
ACTION HmiConnections: 
	hmiIf.ModeChangable := NOT gVariousDemoIf.Sts.Active AND NOT gVariousDemoIf.Sts.Running AND NOT gVariousDemoIf.Sts.Error;
	hmiIf.ResetEnable := gAntiSloshIf.Sts.Error OR gVariousDemoIf.Sts.Error;
	hmiIf.StopEnable := gVariousDemoIf.Sts.Active OR gVariousDemoIf.Sts.Running;
	hmiIf.RunEnable := NOT gVariousDemoIf.Sts.Active AND gAcp6DCtrlIf.Sts.PowerOn;
END_ACTION
