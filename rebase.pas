unit ReBase;

(* Max 64 bits
decimal to binary:      UInt64ToBinary; max 19 decimal digits (to be safe)
binary to decimal:      Convert by summationof powers of 2; max 64 binarary digits

hex to binary:          1 hex digit --> 4 bits [lookup]; max 16 hex digits
binary to hex:          4 bits --> 1 hex digit [lookup]; max 64 binrary digits

octal to binary:        1 octal digit --> 3 bits [lookup]; max 21 octal digits
binary to octal:        3 bits --> 1 octal digit [lookup]; max 63 binary digits
*)

{$mode objFPC}{$H+}{$R+}

// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface

function StrToUInt64(S: string): uint64;

function DecimalStrIsValid(S: string): boolean;
function BinaryStrIsValid(S: string): boolean;
function OctalStrIsValid(S: string): boolean;
function HexadecimalStrIsValid(S: string): boolean;

function UInt64ToBinaryStr(N: uint64): string;
function BinaryStrToUInt64(S: string): uint64;

function HexadecimalStrToBinaryStr(S: string): string;
function BinaryStrToHexadecimalStr(S: string): string;

function OctalStrToBinaryStr(S: string): string;
function BinaryStrToOctalStr(S: string): string;

// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation

uses
  SysUtils, StrUtils;

function DecimalStrIsValid(S: string): boolean;
var
  i : integer;
begin
  Result := True;
  Result := Result and (Length(S) <= 19);
  for i := 1 to Length(S) do begin
    Result := Result and ((Ord(S[i]) >= Ord('0')) and (Ord(S[i]) <= Ord('9')));
  end;
end;

function BinaryStrIsValid(S: string): boolean;
var
  i : integer;
begin
  Result := True;
  Result := Result and (Length(S) <= 64);
  for i := 1 to Length(S) do begin

    Result := Result and ((Ord(S[i]) >= Ord('0')) and (Ord(S[i]) <= Ord('1')));
  end;
end;

function OctalStrIsValid(S: string): boolean;
var
  i : integer;
begin
  Result := True;
  Result := Result and (Length(S) <= 21);
  for i := 1 to Length(S) do begin
    Result := Result and ((Ord(S[i]) >= Ord('0')) and (Ord(S[i]) <= Ord('7')));
  end;
end;

function HexadecimalStrIsValid(S: string): boolean;
var
  i : integer;
  C : char;
begin
  Result := True;
  Result := Result and (Length(S) <= 16);
  for i := 1 to Length(S) do begin
    C := Upcase(S[i]);
    Result := Result and
             (
               ((Ord(C) >= Ord('0')) and (Ord(C) <= Ord('9'))) or
               ((Ord(C) >= Ord('A')) and (Ord(C) <= Ord('F')))
             );
  end;
end;

function StrToUInt64(S: string): uint64;
var
  R : string;
  Sum, Pwr : uint64;
  i, Digit : integer;
begin
  R := ReverseString(S);
  Pwr := 1;
  Sum := 0;
  for i := 1 to Length(R) do begin
    Digit := Ord(R[i])-48;
    Sum := Sum + Pwr*Digit;
    if i < Length(R) then Pwr := Pwr*10;
  end;
  Result := Sum;
end;

function UInt64ToBinaryStr(N: uint64): string;
var
  i: integer;
  S: string;
begin
  S := '';
  for i := 63 downto 0 do
    S := S + Chr(Ord('0') + ((N shr i) and 1));
  S := TrimLeftSet(S, ['0']); // Remove leading zeros
  if S = '' then S := '0';
  Result := S;
end;

function BinaryStrToUInt64(S: string): uint64;
var
  R : string;
  Sum, One, Pwr : uint64;
  i, Bit : integer;
begin
  Sum := 0;
  One := 1;
  R := ReverseString(S);
  for i := 0 to Length(R)-1 do begin
    Bit := Ord(R[i+1])-48;
    Pwr := One shl i;
    Sum := Sum + Pwr*Bit;
  end;
  Result := Sum;
end;

function HexadecimalStrToBinaryStr(S: string): string;
var
  HexLookup : array of string;
  BinDigit, i : integer;
  C : char;
begin
  HexLookup := ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',
                '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'];
  Result := '';
  for i := 1 to Length(S) do begin
    C := Upcase(S[i]);
    if ((Ord(C) >= Ord('0')) and (Ord(C) <= Ord('9'))) then BinDigit := Ord(C)-48;
    if ((Ord(C) >= Ord('A')) and (Ord(C) <= Ord('F'))) then BinDigit := Ord(C)-55;
    Result := Result + HexLookup[BinDigit];
  end;
end;

function BinaryStrToHexadecimalStr(S: string): string;
var
  BinLookup, HexLookup, Padding : array of string;
  BinDigit, i, j : integer;
  Spadded, S4 : string;
begin
  BinLookup := ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',
                '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'];
  HexLookup :=  ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
  // front padding to digits is multiple of 4
  Padding := ['', '0', '00', '000', ''];
  Spadded := Padding[4 - Length(S) mod 4] + S;
  Result := '';
  for i := 0 to (Length(Spadded) div 4) - 1 do begin
    S4 := Copy(Spadded, 1 + 4*i, 4);
    for j := 0 to 15 do begin
        if S4 = BinLookup[j] then Result := Result + HexLookup[j];
    end;
  end;
end;

function OctalStrToBinaryStr(S: string): string;
var
  OctLookup : array of string;
  BinDigit, i : integer;
  C : char;
begin
  OctLookup := ['000', '001', '010', '011', '100', '101', '110', '111'];
  Result := '';
  for i := 1 to Length(S) do begin
    C := S[i];
    if ((Ord(C) >= Ord('0')) and (Ord(C) <= Ord('7'))) then BinDigit := Ord(C)-48;
    Result := Result + OctLookup[BinDigit];
  end;
end;

function BinaryStrToOctalStr(S: string): string;
var
  BinLookup, OctLookup, Padding : array of string;
  BinDigit, i, j : integer;
  Spadded, S3 : string;
begin
  BinLookup := ['000', '001', '010', '011', '100', '101', '110', '111'];
  OctLookup :=  ['0','1','2','3','4','5','6','7'];
  // front padding to digits is multiple of 3
  Padding := ['', '0', '00', ''];
  Spadded := Padding[3 - Length(S) mod 3] + S;
  Result := '';
  for i := 0 to (Length(Spadded) div 3) - 1 do begin
    S3 := Copy(Spadded, 1 + 3*i, 3);
    for j := 0 to 7 do begin
        if S3 = BinLookup[j] then Result := Result + OctLookup[j];
    end;
  end;
end;

end.
