module mac_top #
()
(
	//user control MAC
	
	//input from PHY
	// --input for tx/rx (GMII bus standard here)

	// --input for management SMI(serial management interface),connected to PHY reg(IEEE standard)
	// --function: supervisor & control PHY

	//output to protocol process

	);

mac_config mac_config0(
	);

mac_ctrl mac_ctrl0();

endmodule