unit Main;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
    ReBase;


type

    { TForm1 }

    TForm1 = class(TForm)
        EditDec: TLabeledEdit;
        EditHex: TLabeledEdit;
        EditOct: TLabeledEdit;
        EditBin: TLabeledEdit;
        BitsLabel: TLabel;
        procedure EditBinChange(Sender: TObject);
        procedure EditBinEnter(Sender: TObject);
        procedure EditDecChange(Sender: TObject);
        procedure EditDecEnter(Sender: TObject);
        procedure EditHexChange(Sender: TObject);
        procedure EditHexEnter(Sender: TObject);
        procedure EditOctChange(Sender: TObject);
        procedure EditOctEnter(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private

    public

    end;

var
    Form1: TForm1;
    EditSelected : array of boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.EditDecChange(Sender: TObject);
var
  N : uint64;
begin
  if EditSelected[0] = True then begin;
    EditDec.Font.Color:=clBlack;
    EditHex.Font.Color:=clBlack;
    EditOct.Font.Color:=clBlack;
    EditBin.Font.Color:=clBlack;
    if DecimalStrIsValid(EditDec.Text) then begin
      // Dec --> UINt64 --> Bin --> Hex, Oct
      N := StrToUInt64(EditDec.Text);
      EditBin.Text := UInt64ToBinaryStr(N);
      EditHex.Text := BinaryStrToHexadecimalStr(EditBin.Text);
      EditOct.Text := BinaryStrToOctalStr(EditBin.Text);
      BitsLabel.Caption := IntToStr(Length(EditBin.Text)) + ' bits';
    end
    else begin
      EditDec.Font.Color:=clRed;
      EditBin.Text := '';
      EditHex.Text := '';
      EditOct.Text := '';
    end;
  end;
end;



procedure TForm1.EditBinChange(Sender: TObject);
var
  N : uint64;
begin
  if EditSelected[3] = True then begin
    EditDec.Font.Color:=clBlack;
    EditHex.Font.Color:=clBlack;
    EditOct.Font.Color:=clBlack;
    EditBin.Font.Color:=clBlack;
    if BinaryStrIsValid(EditBin.Text) then begin
      // Bin --> UINt64 --> Dec
      // Bin --> Hex, Oct
      N := BinaryStrToUInt64(EditBin.Text);
      EditDec.Text := IntToStr(N);
      EditHex.Text := BinaryStrToHexadecimalStr(EditBin.Text);
      EditOct.Text := BinaryStrToOctalStr(EditBin.Text);
      BitsLabel.Caption := IntToStr(Length(EditBin.Text)) + ' bits';
    end
    else begin
      EditBin.Font.Color:=clRed;
      EditDec.Text := '';
      EditHex.Text := '';
      EditOct.Text := '';
    end;
  end;
end;

procedure TForm1.EditHexChange(Sender: TObject);
var
  N : uint64;
begin
  if EditSelected[1] = True then begin;
    EditDec.Font.Color:=clBlack;
    EditHex.Font.Color:=clBlack;
    EditOct.Font.Color:=clBlack;
    EditBin.Font.Color:=clBlack;
    if HexadecimalStrIsValid(EditHex.Text) then begin
      // Hex --> Bin --> Oct, UInt64
      // UInt64 --> Dec
      EditBin.Text := HexadecimalStrToBinaryStr(EditHex.Text);
      EditOct.Text := BinaryStrToOctalStr(EditBin.Text);
      N := BinaryStrToUInt64(EditBin.Text);
      EditDec.Text := IntToStr(N);
      BitsLabel.Caption := IntToStr(Length(EditBin.Text)) + ' bits';
    end
    else begin
      EditHex.Font.Color:=clRed;
      EditBin.Text := '';
      EditDec.Text := '';
      EditOct.Text := '';
    end;
  end;
end;

procedure TForm1.EditOctChange(Sender: TObject);
var
  N : uint64;
begin
  if EditSelected[2] = True then begin;
    EditDec.Font.Color:=clBlack;
    EditHex.Font.Color:=clBlack;
    EditOct.Font.Color:=clBlack;
    EditBin.Font.Color:=clBlack;
    if OctalStrIsValid(EditOct.Text) then begin
      // Oct --> Bin --> Hex, UInt64
      // UInt64 --> Dec
      EditBin.Text := OctalStrToBinaryStr(EditOct.Text);
      EditHex.Text := BinaryStrToHexadecimalStr(EditBin.Text);
      N := BinaryStrToUInt64(EditBin.Text);
      EditDec.Text := IntToStr(N);
      BitsLabel.Caption := IntToStr(Length(EditBin.Text)) + ' bits';
    end
    else begin
      EditOct.Font.Color:=clRed;
      EditBin.Text := '';
      EditDec.Text := '';
      EditHex.Text := '';
    end;
  end;
end;

procedure TForm1.EditDecEnter(Sender: TObject);
begin
  EditSelected := [True, False, False, False];
end;

procedure TForm1.EditBinEnter(Sender: TObject);
begin
  EditSelected := [False, False, False, True];
end;

procedure TForm1.EditHexEnter(Sender: TObject);
begin
  EditSelected := [False, True, False, False];
end;

procedure TForm1.EditOctEnter(Sender: TObject);
begin
  EditSelected := [False, False, True, False];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EditSelected := [True, False, False, False];
end;



end.

