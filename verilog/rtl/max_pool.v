// SPDX-FileCopyrightText: 2021 renzym.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Yasir Javed <info@renzym.com>

//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	max_pool
// Module Name:		Max Pool
// Description: 	One dimentional Maxpool between two values, can be enabled/disabled
//
//					
// Dependencies:	 
//
//////////////////////////////////////////////////////////////////////////////////
module max_pool
	#(
		parameter DWIDTH = 8
	)
	(
	input						clk,
	input						reset,
	input						en_maxpool,
	input		[DWIDTH-1:0]	data_in,
	input						valid_in,
	
	output reg	[DWIDTH-1:0]	data_out,
	output reg					valid_out
	);

	reg	[DWIDTH-1:0]	data_r;
	reg	[DWIDTH-1:0]	data_r_r;
	reg	[DWIDTH-1:0]	max_pool_out;
	reg					max_pool_valid;

	always@(posedge clk)
		if(reset)			data_r		<= 0;
		else if(valid_in)	data_r		<= data_in;

	always@* max_pool_out <= (data_r > data_in) ? data_r: data_in;
	

	reg toggle;	
	always@(posedge clk)
		if		(reset | ~en_maxpool)	toggle <= 0;
		else if (valid_in)				toggle <= ~toggle;
	
	always@* max_pool_valid <= toggle & valid_in;

	always@(posedge clk) 
		if(reset)	
		begin
			data_out 	<= 0;
		    valid_out	<= 0;
		end
		else
		begin
			data_out 	<= en_maxpool ? max_pool_out	: data_in;
		    valid_out	<= en_maxpool ? max_pool_valid	: valid_in;
		end

endmodule
