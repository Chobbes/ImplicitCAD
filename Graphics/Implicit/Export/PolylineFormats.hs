
-- Implicit CAD. Copyright (C) 2011, Christopher Olah (chris@colah.ca)
-- Released under the GNU GPL, see LICENSE

module Graphics.Implicit.Export.PolylineFormats where

import Graphics.Implicit.Definitions

svg polylines = text
	where
		svglines = concat $ map (\line -> 
				"  <polyline points=\"" 
				++ concat (map (\(x,y) -> " " ++ show x ++ "," ++ show y) line)
				++ "\" style=\"stroke:rgb(0,0,255);stroke-width:1;fill:none;\"/> \n" ) 
				polylines	
		text = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\"> \n" 
			++ svglines		
			++ "</svg> "

hacklabLaserGCode polylines = text
	where
		gcodeHeader = 
			"(generated by ImplicitCAD, based of hacklab wiki example)\n"
			++"M63 P0 (laser off)\n"
			++"G0 Z0.002 (laser off)\n"
			++"G21 (units=mm)\n"
			++"F400 (set feedrate)\n"
			++"M3 S1 (enable laser)\n"
			++"\n"
		gcodeFooter = 
			"M5 (disable laser)\n"
			++"G00 X0.0 Y0.0 (move to 0)\n"
			++"M2 (end)"
		gcodeXY :: ℝ2 -> [Char]
		gcodeXY (x,y) = "X"++ show x ++" Y"++ show y 
		interpretPolyline (start:others) = 
			"G00 "++ gcodeXY start ++ "\n"
			++ "M62 P0 (laser on)\n"
			++ concat (map (\p -> "G01 " ++ (gcodeXY p) ++ "\n") others)
			++ "M63 P0 (laser off)\n\n"
		text = gcodeHeader
			++ (concat $ map interpretPolyline polylines)
			++ gcodeFooter

