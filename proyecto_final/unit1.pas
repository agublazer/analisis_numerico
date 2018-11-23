unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, uCmdBox;

type

  { TForm1 }

  TForm1 = class(TForm)
    CmdBox1: TCmdBox;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    function is_function(Input:string):Integer;
    function var_type(var_content:string):String;
    function get_value(input:string):string;
    procedure search_and_update(var_name:string;var_content:string);
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure ParseVar(Input: string);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.is_function(Input:string):Integer;
var temp:String;
    iPos:Integer;
begin
    iPos:=pos('(',Input);
    temp:=Copy(Input,0,iPos-1);
    temp:=StringReplace(temp, ' ', '', [rfReplaceAll]); //Remove spaces
    temp:=LowerCase(temp);
    if temp = 'root' then
        begin
            result:=0;
            exit();
        end;
    if temp = 'plot2d' then
        begin
            result:=1;
            exit();
        end;
    if temp = 'polyroot' then
        begin
            result:=2;
            exit();
        end;
    if temp = 'polynomial' then
        begin
            result:=3;
            exit();
        end;
    if temp = 'eval' then
        begin
            result:=4;
            exit();
        end;
    if temp = 'senl' then
        begin
            result:=5;
            exit();
        end;
    if temp = 'integral' then
        begin
            result:=6;
            exit();
        end;
    if temp = 'area' then
        begin
            result:=7;
            exit();
        end;
    if temp = 'edo' then
        begin
            result:=8;
            exit();
        end;
    result:=9;
end;
function TForm1.var_type(var_content:string):string;
begin
    if (var_content[1] = '"') and (var_content[length(var_content)]='"') then
        begin
            result:= 'String';
            exit();
        end;
    if pos('.',var_content) <> 0 then
        begin
            result:= 'Float';
            exit();
        end;
    result:='undefined';
end;

function TForm1.get_value(input:string):string;
var i: Integer;
begin
     for i:=0 to StringGrid1.RowCount-1 do
         begin
              if StringGrid1.Cells[0,i] = input then
                 begin
                      Result:= StringGrid1.Cells[1,i];
                      exit();
                 end;
         end;
     Result:= 'undefined';
     exit();
end;

procedure TForm1.search_and_update(var_name:string; var_content: string);
var iFunc,i: Integer;
    iType: String;
begin
    iFunc:= is_function(var_content);
    iType:= var_type(var_content);
    for i:=0 to StringGrid1.RowCount-1 do
    begin
        if StringGrid1.Cells[0,i] = var_name then
            begin
                StringGrid1.Cells[1,i] := var_content;
                StringGrid1.Cells[2,i] := iType;
                exit();
            end;
    end;
    StringGrid1.InsertRowWithValues(1,[var_name, var_content, iType]);
end;

procedure TForm1.ParseVar(Input: string);
var iPos: Integer;
var var_name, var_content: String;
begin
  iPos := pos('=',Input);
  if iPos <> 0 then
     begin
         var_name:= Copy(Input, 0,iPos-1);
         var_content:= Copy(Input, iPos+1, Length(Input) - iPos);
         var_name := StringReplace(var_name, ' ', '', [rfReplaceAll]); //Remove spaces
         var_content := StringReplace(var_content, ' ', '', [rfReplaceAll]); //Remove spaces
         if var_content = '' then
             begin
                 ShowMessage('Falta asignar un valor a la variable');
                 exit();
             end;
         search_and_update(var_name, var_content);
     end
  else
     begin
         if (is_function(Input) = 9 )then
             begin
                 CmdBox1.Writeln('input>  '+get_value(Input));
                 exit();
             end;
         search_and_update('ans', Input);
     end;
end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
begin
  Edit1.Text:=Input;
  ParseVar(input);
  CmdBox1.StartRead(clWhite,clBlue,'input>  ',clMaroon,clSkyBlue);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox1.StartRead(clWhite,clBlue,'input>  ',clMaroon,clSkyBlue);
end;

end.

