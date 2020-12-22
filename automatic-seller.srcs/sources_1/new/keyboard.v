`timescale 1ns / 1ps
module keyboard(
							clk,             // ������������ʱ��: 50Mhz
							rst_n,           // �������ϸ�λ����
							key_out_y,       // ���������̵����ź�(KEY0~KEY3)
							key_in_x,        // ���������̵����ź�(KEY4~KEY7)
							key_value,        
							key_flag
						);

//========================================================
// PORT declarations
//========================================================						
input        		clk; 
input				rst_n;
output	reg	[3:0]	key_out_y;
input		[3:0]	key_in_x;
output	reg	[3:0]	key_value;
output	reg			key_flag;

//�Ĵ�������
reg [19:0] count;

//==============================================
// ���������̵����źţ�20msɨ��������һ��,����Ƶ��С�ڰ���ë��Ƶ�ʣ��൱���˳����˸�Ƶë���źš�
//==============================================
	always @(posedge clk or negedge rst_n)begin//���ʱ�ӵ������غ͸�λ���½���
		if(!rst_n) begin               //��λ�źŵ���Ч
			count		<=	20'd0;        //��������0
			key_out_y	<=	4'b1111;  
			end		
		else begin
			if(count == 20'd0)begin          //0msɨ���һ�о������          
				key_out_y	<= 4'b1110;      //��ʼɨ���һ�о������,��һ�����0
				count		<= count + 20'b1; //��������1
				end
			else if(count == 20'd249_999)begin //5msɨ��ڶ��о������,5ms����(50M/200-1=249_999)           
				key_out_y	<= 4'b1101;   //��ʼɨ��ڶ��о������,�ڶ������0
				count		<= count + 20'b1; //��������1
				end				
			else if(count ==20'd499_999)begin   //10msɨ������о������,10ms����(50M/100-1=499_999)           
				key_out_y	<= 4'b1011;   //ɨ������о������,���������0
				count		<= count + 20'b1; //��������1
				end	
			else if(count ==20'd749_999)begin   //15msɨ������о������,15ms����(50M/67.7-1=749_999)           
				key_out_y	<= 4'b0111;   //ɨ������о������,���������0
				count		<= count + 20'b1; //��������1
				end				
			else if(count ==20'd999_999)begin  //20ms����(50M/50-1=999_999)		   
				count <= 0;             //������Ϊ0
				end	
			else
				count <= count + 20'b1;    //��������1
			
     end
end
//====================================================
// �����еİ����ź�
//====================================================
reg [3:0] key_h1_scan;    //��һ�а���ɨ��ֵKEY
reg [3:0] key_h1_scan_r;  //��һ�а���ɨ��ֵ�Ĵ���KEY
reg [3:0] key_h2_scan;    //�ڶ��а���ɨ��ֵKEY
reg [3:0] key_h2_scan_r;  //�ڶ��а���ɨ��ֵ�Ĵ���KEY
reg [3:0] key_h3_scan;    //�����а���ɨ��ֵKEY
reg [3:0] key_h3_scan_r;  //�����а���ɨ��ֵ�Ĵ���KEY
reg [3:0] key_h4_scan;    //�����а���ɨ��ֵKEY
reg [3:0] key_h4_scan_r;  //�����а���ɨ��ֵ�Ĵ���KEY
always @(posedge clk)
	begin
		if(!rst_n) begin               //��λ�źŵ���Ч
			key_h1_scan <= 4'b1111;     
			key_h2_scan <= 4'b1111;          
			key_h3_scan <= 4'b1111;          
			key_h4_scan <= 4'b1111;        
		end		
		else begin
		  if(count == 20'd124_999)           //2.5msɨ���һ�о������ֵ
			   key_h1_scan<=key_in_x;         //ɨ���һ�еľ������ֵ
		  else if(count == 20'd374_999)      //7.5msɨ��ڶ��о������ֵ
			   key_h2_scan<=key_in_x;         //ɨ��ڶ��еľ������ֵ
		  else if(count == 20'd624_999)      //12.5msɨ������о������ֵ
			   key_h3_scan<=key_in_x;         //ɨ������еľ������ֵ
		  else if(count == 20'd874_999)      //17.5msɨ������о������ֵ
			   key_h4_scan<=key_in_x;         //ɨ������еľ������ֵ 
		end
end

//====================================================
// �����ź�����һ��ʱ�ӽ���
//====================================================
always @(posedge clk)
   begin
		 key_h1_scan_r <= key_h1_scan;   	
		 key_h2_scan_r <= key_h2_scan; 
		 key_h3_scan_r <= key_h3_scan; 
		 key_h4_scan_r <= key_h4_scan;  
	end 
   
wire [3:0] flag_h1_key = key_h1_scan_r[3:0] & (~key_h1_scan[3:0]);  //����⵽�������½��ر仯ʱ������ð��������£�������Ч 
wire [3:0] flag_h2_key = key_h2_scan_r[3:0] & (~key_h2_scan[3:0]);  //����⵽�������½��ر仯ʱ������ð��������£�������Ч 
wire [3:0] flag_h3_key = key_h3_scan_r[3:0] & (~key_h3_scan[3:0]);  //����⵽�������½��ر仯ʱ������ð��������£�������Ч 
wire [3:0] flag_h4_key = key_h4_scan_r[3:0] & (~key_h4_scan[3:0]);  //����⵽�������½��ر仯ʱ������ð��������£�������Ч 

//=====================================================
// LED�ƿ���,��������ʱ,��ص�LED�����ת
//=====================================================
reg [15:0] temp_led;
always @ (posedge clk or negedge rst_n)      //���ʱ�ӵ������غ͸�λ���½���
begin
    if (!rst_n)begin                 //��λ�źŵ���Ч
         key_value <= 4'd0;     //LED�ƿ����ź����Ϊ��, LED��ȫ��
		 key_flag  <= 1'b0;
		 end
    else
         begin            
                  if ( flag_h1_key[0] ) begin key_value <= 4'h1  ; key_flag <= 1'b1; end
             else if ( flag_h1_key[1] ) begin key_value <= 4'h4  ; key_flag <= 1'b1; end
             else if ( flag_h1_key[2] ) begin key_value <= 4'h7  ; key_flag <= 1'b1; end
             else if ( flag_h1_key[3] ) begin key_value <= 4'hE  ; key_flag <= 1'b1; end

             else if ( flag_h2_key[0] ) begin key_value <= 4'h2  ; key_flag <= 1'b1; end
             else if ( flag_h2_key[1] ) begin key_value <= 4'h5  ; key_flag <= 1'b1; end
             else if ( flag_h2_key[2] ) begin key_value <= 4'h8  ; key_flag <= 1'b1; end
             else if ( flag_h2_key[3] ) begin key_value <= 4'h0  ; key_flag <= 1'b1; end

             else if ( flag_h3_key[0] ) begin key_value <= 4'h3  ; key_flag <= 1'b1; end
             else if ( flag_h3_key[1] ) begin key_value <= 4'h6  ; key_flag <= 1'b1; end
             else if ( flag_h3_key[2] ) begin key_value <= 4'h9  ; key_flag <= 1'b1; end
             else if ( flag_h3_key[3] ) begin key_value <= 4'hF  ; key_flag <= 1'b1; end
			 
             else if ( flag_h4_key[0] ) begin key_value <= 4'hA  ; key_flag <= 1'b1; end
             else if ( flag_h4_key[1] ) begin key_value <= 4'hB  ; key_flag <= 1'b1; end
             else if ( flag_h4_key[2] ) begin key_value <= 4'hC  ; key_flag <= 1'b1; end
             else if ( flag_h4_key[3] ) begin key_value <= 4'hD  ; key_flag <= 1'b1; end
			 else begin key_value <= 4'd0 ; key_flag <= 1'b0;end
         end
end

endmodule