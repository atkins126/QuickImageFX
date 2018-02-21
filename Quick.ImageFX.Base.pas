{ ***************************************************************************

  Copyright (c) 2016-2018 Kike P�rez

  Unit        : Quick.ImageFX.Base
  Description : Image manipulation with GDI
  Author      : Kike P�rez
  Version     : 3.0
  Created     : 21/11/2017
  Modified    : 21/02/2018

  This file is part of QuickImageFX: https://github.com/exilon/QuickImageFX

 ***************************************************************************

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

 *************************************************************************** }
unit Quick.ImageFX.Base;

interface

uses
  Classes,
  System.SysUtils,
  Winapi.ShellAPI,
  Winapi.Windows,
  Vcl.Controls,
  Graphics,
  System.Math,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  System.Net.HttpClient,
  Quick.ImageFX.Types;

type

 TImageFXBase = class(TInterfacedObject,IImageFX,IImageFXTransform)
  private
    fJPGQualityLevel : TJPGQualityLevel;
    fPNGCompressionLevel : TPNGCompressionLevel;
    fProgressiveJPG : Boolean;
    fResizeOptions : TResizeOptions;
    fHTTPOptions : THTTPOptions;
    fLastResult : TImageActionResult;
    fExifRotation : Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property JPGQualityPercent : TJPGQualityLevel read fJPGQualityLevel write fJPGQualityLevel;
    property PNGCompressionLevel : TPNGCompressionLevel read fPNGCompressionLevel write fPNGCompressionLevel;
    property ProgressiveJPG : Boolean read fProgressiveJPG write fProgressiveJPG;
    property ResizeOptions : TResizeOptions read fResizeOptions write fResizeOptions;
    property HTTPOptions : THTTPOptions read fHTTPOptions write fHTTPOptions;
    property ExifRotation : Boolean read fExifRotation write fExifRotation;
    property LastResult : TImageActionResult read fLastResult write fLastResult;
    function FindGraphicClass(const Buffer; const BufferSize: Int64; out GraphicClass: TGraphicClass): Boolean; overload;
    function FindGraphicClass(Stream: TStream; out GraphicClass: TGraphicClass): Boolean; overload;
    function GetImageFmtExt(imgFormat : TImageFormat) : string;
    function GetFileInfo(AExt : string; var AInfo : TSHFileInfo; ALargeIcon : Boolean = false) : boolean;
    function GetHTTPStream(urlImage : string; out HTTPReturnCode : Integer) : TMemoryStream;
    class function GetAspectRatio(cWidth, cHeight : Integer) : string; virtual; abstract;
    function LoadFromFile(fromfile : string; CheckIfFileExists : Boolean = False) : TImageFX; virtual; abstract;
    function LoadFromFile2(fromfile : string; CheckIfFileExists : Boolean = False) : TImageFX; virtual; abstract;
    function LoadFromStream(stream : TStream) : TImageFX; virtual; abstract;
    function LoadFromString(str : string) : TImageFX; virtual; abstract;
    function LoadFromImageList(imgList : TImageList; ImageIndex : Integer) : TImageFX; virtual; abstract;
    function LoadFromIcon(Icon : TIcon) : TImageFX; virtual; abstract;
    function LoadFromFileIcon(FileName : string; IconIndex : Word) : TImageFX; virtual; abstract;
    function LoadFromFileExtension(aFilename : string; LargeIcon : Boolean) : TImageFX; virtual; abstract;
    function LoadFromResource(ResourceName : string) : TImageFX; virtual; abstract;
    function LoadFromHTTP(urlImage : string; out HTTPReturnCode : Integer; RaiseExceptions : Boolean = False) : TImageFX; virtual; abstract;
    procedure GetResolution(var x,y : Integer); overload; virtual; abstract;
    function GetResolution : string; overload; virtual; abstract;
    function AspectRatio : Double; virtual; abstract;
    function AspectRatioStr : string; virtual; abstract;
    function Clone : TImageFX; virtual; abstract;
    function IsGray : Boolean; virtual; abstract;
    function Clear(pcolor : TColor = clWhite) : TImageFX; virtual; abstract;
    function Resize(w, h : Integer) : TImageFX; overload; virtual; abstract;
    function Resize(w, h : Integer; ResizeMode : TResizeMode; ResizeFlags : TResizeFlags = []; ResampleMode : TResamplerMode = rsLinear) : TImageFX; overload; virtual; abstract;
    function DrawCentered(png : TPngImage; alpha : Double = 1) : TImageFX; overload; virtual; abstract;
    function DrawCentered(stream: TStream; alpha : Double = 1) : TImageFX; overload; virtual; abstract;
    function Draw(png : TPngImage; x, y : Integer; alpha : Double = 1) : TImageFX; overload; virtual; abstract;
    function Draw(jpg : TJPEGImage; x: Integer; y: Integer; alpha: Double = 1) : TImageFX; overload; virtual; abstract;
    function Draw(stream : TStream; x, y : Integer; alpha : Double = 1) : TImageFX; overload; virtual; abstract;
    function Rotate90 : TImageFX; virtual; abstract;
    function Rotate180 : TImageFX; virtual; abstract;
    function Rotate270 : TImageFX; virtual; abstract;
    function RotateBy(RoundAngle : Integer) : TImageFX; virtual; abstract;
    function RotateAngle(RotAngle : Single) : TImageFX; virtual; abstract;
    function FlipX : TImageFX; virtual; abstract;
    function FlipY : TImageFX; virtual; abstract;
    function GrayScale : TImageFX; virtual; abstract;
    function ScanlineH : TImageFX; virtual; abstract;
    function ScanlineV : TImageFX; virtual; abstract;
    function Lighten(StrenghtPercent : Integer = 30) : TImageFX; virtual; abstract;
    function Darken(StrenghtPercent : Integer = 30) : TImageFX; virtual; abstract;
    function Tint(mColor : TColor) : TImageFX; virtual; abstract;
    function TintAdd(R, G , B : Integer) : TImageFX; virtual; abstract;
    function TintBlue : TImageFX; virtual; abstract;
    function TintRed : TImageFX; virtual; abstract;
    function TintGreen : TImageFX; virtual; abstract;
    function Solarize : TImageFX; virtual; abstract;
    function Rounded(RoundLevel : Integer = 27) : TImageFX; virtual; abstract;
    procedure SaveToPNG(outfile : string); virtual; abstract;
    procedure SaveToJPG(outfile : string); virtual; abstract;
    procedure SaveToBMP(outfile : string); virtual; abstract;
    procedure SaveToGIF(outfile : string); virtual; abstract;
    class function ColorToRGBValues(PColor: TColor) : TRGB;
    class function RGBValuesToColor(RGBValues : TRGB) : TColor;
    class function ActionResultToString(aImgResult : TImageActionResult) : string;
    class function ColorIsLight(Color: TColor): Boolean;
    class function ColorIsDark(Color: TColor): Boolean;
    class function GetLightColor(BaseColor: TColor): TColor;
    class function GetDarkColor(BaseColor: TColor): TColor;
    class function ChangeColorIntesity(MyColor: TColor; Factor: Double): TColor;
    class procedure CleanTransparentPng(var png: TPngImage; NewWidth, NewHeight: Integer);
    class function JPEGCorruptionCheck(jpg : TJPEGImage): Boolean; overload;
    class function JPEGCorruptionCheck(const stream : TMemoryStream): Boolean; overload;
    class procedure AutoCropBitmap(var bmp : TBitmap; aColor : TColor);
  end;

  function GCD(a,b : integer):integer;

implementation

{ TImageFXBase }

function GCD(a,b : integer):integer;
begin
  if (b mod a) = 0 then Result := a
    else Result := GCD(b, a mod b);
end;

constructor TImageFXBase.Create;
begin
  ProgressiveJPG := False;
  JPGQualityPercent := 85;
  PNGCompressionLevel := 7;
  LastResult := arNone;
  ResizeOptions := TResizeOptions.Create;
  ResizeOptions.NoMagnify := False;
  ResizeOptions.ResizeMode := rmStretch;
  ResizeOptions.ResamplerMode := rsAuto;
  ResizeOptions.Center := False;
  ResizeOptions.FillBorders := False;
  ResizeOptions.BorderColor := clWhite;
  HTTPOptions := THTTPOptions.Create;
  HTTPOptions.UserAgent := DEF_USERAGENT;
  HTTPOptions.ConnectionTimeout := DEF_CONNECTION_TIMEOUT;
  HTTPOptions.ResponseTimeout := DEF_RESPONSE_TIMEOUT;
  HTTPOptions.AllowCookies := False;
  HTTPOptions.HandleRedirects := True;
  HTTPOptions.MaxRedirects := 10;
  fExifRotation := True;
end;

destructor TImageFXBase.Destroy;
begin
  if Assigned(ResizeOptions) then ResizeOptions.Free;
  if Assigned(HTTPOptions) then HTTPOptions.Free;
  inherited;
end;

function TImageFXBase.FindGraphicClass(const Buffer; const BufferSize: Int64; out GraphicClass: TGraphicClass): Boolean;
var
  LongWords: array[Byte] of LongWord absolute Buffer;
  Words: array[Byte] of Word absolute Buffer;
begin
  GraphicClass := nil;
  Result := False;
  if BufferSize < MinGraphicSize then Exit;
  case Words[0] of
    $4D42: GraphicClass := TBitmap;
    $D8FF: GraphicClass := TJPEGImage;
    $4949: if Words[1] = $002A then GraphicClass := TWicImage; //i.e., TIFF
    $4D4D: if Words[1] = $2A00 then GraphicClass := TWicImage; //i.e., TIFF
  else
    begin
      if Int64(Buffer) = $A1A0A0D474E5089 then GraphicClass := TPNGImage
      else if LongWords[0] = $9AC6CDD7 then GraphicClass := TMetafile
       else if (LongWords[0] = 1) and (LongWords[10] = $464D4520) then GraphicClass := TMetafile
        else if StrLComp(PAnsiChar(@Buffer), 'GIF', 3) = 0 then GraphicClass := TGIFImage
         else if Words[1] = 1 then GraphicClass := TIcon;
    end;
  end;
  Result := (GraphicClass <> nil);
end;

function TImageFXBase.FindGraphicClass(Stream: TStream; out GraphicClass: TGraphicClass): Boolean;
var
  Buffer: PByte;
  CurPos: Int64;
  BytesRead: Integer;
begin
  if Stream is TCustomMemoryStream then
  begin
    Buffer := TCustomMemoryStream(Stream).Memory;
    CurPos := Stream.Position;
    Inc(Buffer, CurPos);
    Result := FindGraphicClass(Buffer^, Stream.Size - CurPos, GraphicClass);
  end
  else
  begin
    GetMem(Buffer, MinGraphicSize);
    try
      BytesRead := Stream.Read(Buffer^, MinGraphicSize);
      Stream.Seek(-BytesRead, soCurrent);
      Result := FindGraphicClass(Buffer^, BytesRead, GraphicClass);
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TImageFXBase.GetImageFmtExt(imgFormat : TImageFormat) : string;
begin
  case imgFormat of
    ifBMP: Result := '.bmp';
    ifJPG: Result := '.jpg';
    ifPNG: Result := '.png';
    ifGIF: Result := '.gif';
    else Result := '.jpg';
  end;
end;

function TImageFXBase.GetFileInfo(AExt : string; var AInfo : TSHFileInfo; ALargeIcon : Boolean = False) : Boolean;
var uFlags : integer;
begin
  FillMemory(@AInfo,SizeOf(TSHFileInfo),0);
  uFlags := SHGFI_ICON+SHGFI_TYPENAME+SHGFI_USEFILEATTRIBUTES;
  if ALargeIcon then uFlags := uFlags + SHGFI_LARGEICON
    else uFlags := uFlags + SHGFI_SMALLICON;
  if SHGetFileInfo(PChar(AExt),FILE_ATTRIBUTE_NORMAL,AInfo,SizeOf(TSHFileInfo),uFlags) = 0 then Result := False
    else Result := True;
end;

function TImageFXBase.GetHTTPStream(urlImage : string; out HTTPReturnCode : Integer) : TMemoryStream;
var
  http : THTTPClient;
  StatusCode : Integer;
begin
  StatusCode := 500;
  LastResult := arUnknowFmtType;
  http := THTTPClient.Create;
  try
    http.UserAgent := HTTPOptions.UserAgent;
    http.HandleRedirects := HTTPOptions.HandleRedirects;
    http.MaxRedirects := HTTPOptions.MaxRedirects;
    http.AllowCookies := HTTPOptions.AllowCookies;
    http.ConnectionTimeout := HTTPOptions.ConnectionTimeout;
    http.ResponseTimeout := HTTPOptions.ResponseTimeout;
    Result := TMemoryStream.Create;
    StatusCode := http.Get(urlImage,Result).StatusCode;
    if StatusCode = 200 then
    begin
      if (Result = nil) or (Result.Size = 0)  then
      begin
        StatusCode := 500;
        raise Exception.Create('http stream empty!');
      end
      else LastResult := arOk;
    end else raise Exception.Create(Format('Error %d retrieving url %s',[StatusCode,urlImage]));
  finally
    HTTPReturnCode := StatusCode;
    http.Free;
  end;
end;

class function TImageFXBase.ColorToRGBValues(PColor: TColor): TRGB;
begin
  Result.B := PColor and $FF;
  Result.G := (PColor shr 8) and $FF;
  Result.R := (PColor shr 16) and $FF;
end;

class function TImageFXBase.RGBValuesToColor(RGBValues : TRGB) : TColor;
begin
  Result := RGB(RGBValues.R,RGBValues.G,RGBValues.B);
end;

class function TImageFXBase.ActionResultToString(aImgResult: TImageActionResult) : string;
begin
  case aImgResult of
    arNone : Result := 'None';
    arOk : Result := 'Action Ok';
    arAlreadyOptim : Result := 'Already optimized';
    arRotateError : Result := 'Rotate or Flip error';
    arColorizeError : Result := 'Error manipulating pixel colors';
    arZeroBytes : Result := 'File/Stream is empty';
    arResizeError : Result := 'Resize error';
    arConversionError : Result := 'Conversion error';
    arUnknowFmtType : Result := 'Unknow Format type';
    arFileNotExist : Result := 'File not exists';
    arUnknowError : Result := 'Unknow error';
    arNoOverwrited : Result := 'Not overwrited';
    arCorruptedData : Result := 'Corrupted data';
    else Result := Format('Unknow error (%d)',[Integer(aImgResult)]);
  end;
end;

{Checks if color is light}
class function TImageFXBase.ColorIsLight(Color: TColor): Boolean;
begin
  Color := ColorToRGB(Color);
  Result := ((Color and $FF) + (Color shr 8 and $FF) +
  (Color shr 16 and $FF))>= $180;
end;

{Checks if color is dark}
class function TImageFXBase.ColorIsDark(Color: TColor): Boolean;
begin
  Result := not ColorIsLight(Color);
end;

{Convierte el color en m�s claro}
class function TImageFXBase.GetLightColor(BaseColor: TColor): TColor;
begin
  Result := RGB(Min(GetRValue(ColorToRGB(BaseColor)) + 64, 255),
    Min(GetGValue(ColorToRGB(BaseColor)) + 64, 255),
    Min(GetBValue(ColorToRGB(BaseColor)) + 64, 255));
end;

{Convierte el color en m�s oscuro}
class function TImageFXBase.GetDarkColor(BaseColor: TColor): TColor;
begin
  Result := RGB(Max(GetRValue(ColorToRGB(BaseColor)) - 64, 0),
    Max(GetGValue(ColorToRGB(BaseColor)) - 64, 0),
    Max(GetBValue(ColorToRGB(BaseColor)) - 64, 0));
end;

{Convierte el color en m�s oscuro o claro definiendo la intensidad}
class function TImageFXBase.ChangeColorIntesity(MyColor: TColor; Factor: Double): TColor;
var
  Red, Green, Blue: Integer;
  ChangeAmount: Double;
begin
  // get the color components
  Red := MyColor and $FF;
  Green := (MyColor shr 8) and $FF;
  Blue := (MyColor shr 16) and $FF;

  // calculate the new color
  ChangeAmount := Red * Factor;
  Red := Min(Max(Round(Red + ChangeAmount), 0), 255);
  ChangeAmount := Green * Factor;
  Green := Min(Max(Round(Green + ChangeAmount), 0), 255);
  ChangeAmount := Blue * Factor;
  Blue := Min(Max(Round(Blue + ChangeAmount), 0), 255);

  // and return it as a TColor
  Result := Red or (Green shl 8) or (Blue shl 16);
end;

class function TImageFXBase.JPEGCorruptionCheck(jpg : TJPEGImage): Boolean;
var
  w1 : Word;
  w2 : Word;
  ms : TMemoryStream;
begin
  Assert(SizeOf(WORD) = 2);

  ms := TMemoryStream.Create;
  try
    jpg.SaveToStream(ms);
    Result := Assigned(ms);

    if Result then
    begin
      ms.Seek(0, soFromBeginning);
      ms.Read(w1,2);

      ms.Position := ms.Size - 2;
      ms.Read(w2,2);

      Result := (w1 = $D8FF) and (w2 = $D9FF);
    end;
  finally
    ms.Free;
  end;
end;

class function TImageFXBase.JPEGCorruptionCheck(const stream: TMemoryStream): Boolean;
var
  w1 : Word;
  w2 : Word;
begin
  Assert(SizeOf(WORD) = 2);

  Result := Assigned(stream);

  if Result then
  begin
    stream.Seek(0, soFromBeginning);
    stream.Read(w1,2);

    stream.Position := stream.Size - 2;
    stream.Read(w2,2);

    Result := (w1 = $D8FF) and (w2 = $D9FF);
  end;
end;

class procedure TImageFXBase.CleanTransparentPng(var png: TPngImage; NewWidth, NewHeight: Integer);
var
  BasePtr: Pointer;
begin
  png := TPngImage.CreateBlank(COLOR_RGBALPHA, 16, NewWidth, NewHeight);

  BasePtr := png.AlphaScanline[0];
  ZeroMemory(BasePtr, png.Header.Width * png.Header.Height);
end;

function CalcCloseCrop(ABitmap: TBitmap; const ABackColor: TColor) : TRect;
var
  X: Integer;
  Y: Integer;
  Color: TColor;
  Pixel: PRGBTriple;
  RowClean: Boolean;
  LastClean: Boolean;
begin
  if ABitmap.PixelFormat <> pf24bit then
    raise Exception.Create('Incorrect bit depth, bitmap must be 24-bit!');

  LastClean := False;
  Result := Rect(ABitmap.Width, ABitmap.Height, 0, 0);

  for Y := 0 to ABitmap.Height-1 do
  begin
    RowClean := True;
    Pixel := ABitmap.ScanLine[Y];
    for X := 0 to ABitmap.Width - 1 do
    begin
      Color := RGB(Pixel.rgbtRed, Pixel.rgbtGreen, Pixel.rgbtBlue);
      if Color <> ABackColor then
      begin
        RowClean := False;
        if X < Result.Left then
          Result.Left := X;
        if X + 1 > Result.Right then
          Result.Right := X + 1;
      end;
      Inc(Pixel);
    end;

    if not RowClean then
    begin
      if not LastClean then
      begin
        LastClean := True;
        Result.Top := Y;
      end;
      if Y + 1 > Result.Bottom then
        Result.Bottom := Y + 1;
    end;
  end;

  if Result.IsEmpty then
  begin
    if Result.Left = ABitmap.Width then
      Result.Left := 0;
    if Result.Top = ABitmap.Height then
      Result.Top := 0;
    if Result.Right = 0 then
      Result.Right := ABitmap.Width;
    if Result.Bottom = 0 then
      Result.Bottom := ABitmap.Height;
  end;
end;

class procedure TImageFXBase.AutoCropBitmap(var bmp : TBitmap; aColor : TColor);
var
  auxbmp : TBitmap;
  rect : TRect;
begin
  rect := CalcCloseCrop(bmp,aColor);
  auxbmp := TBitmap.Create;
  try
    auxbmp.PixelFormat := bmp.PixelFormat;
    auxbmp.Width  := rect.Width;
    auxbmp.Height := rect.Height;
    BitBlt(auxbmp.Canvas.Handle, 0, 0, rect.BottomRight.x, rect.BottomRight.Y, bmp.Canvas.Handle, rect.TopLeft.x, rect.TopLeft.Y, SRCCOPY);
    bmp.Assign(auxbmp);
  finally
    auxbmp.Free;
  end;
end;

end.
