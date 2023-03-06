{ Angel Giovanny Martinez Soto Nc: 19940214 8AS

T2.6 Diálogos entre forms.
Realizar la práctica siguiendo los pasos del documento anexo a este documento.
Esta tarea consiste en lanzar una ventana para editar un texto, ese texto se va guardando
en un archivo, si el usuario se sale de esa ventana, hay que preguntar si desea guardar los
cambios, en el caso de que los cambios se guarden, estos se deben guardar fìsicamente en el
dispositivo, para que el archivo pueda ser cargado en el futuro. Si el usuario no hace cambios,
entonces "no es necesario mostrar el diàlogo, puesto que no hubo cambios".

Nota: debe tener cuidado de intentar abrir un archivo que no existe, si este archivo no existe
y lo intenta abrir, la app lanzará una excepción. Para evitar esto, hay que usar las funciones
de verficación correspondientes.
}


unit uData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.DialogService
{$IFDEF ANDROID}
    , Androidapi.JNI.Widget, Androidapi.Helpers
{$ENDIF};

type
  TfrmData = class(TForm)
    edtData: TEdit;
    btnBack: TButton;
    memLog: TMemo;
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnBackClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowMessageToast(const pMsg: String; pDuration: Integer);

  var
    saveFileClose: Boolean;
    ruta: string;

  end;

var
  frmData: TfrmData;

implementation

{$R *.fmx}

uses System.IOUtils;

procedure TfrmData.ShowMessageToast(const pMsg: String; pDuration: Integer);
begin
{$IFDEF ANDROID}
  TThread.Synchronize(nil,
    procedure
    begin
      TJToast.JavaClass.makeText(TAndroidHelper.Context,
        StrToJCharSequence(pMsg), pDuration).show
    end);
{$ENDIF}
end;

procedure TfrmData.btnBackClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmData.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

var
  msg: string;
  CloseOk: Boolean;

begin

  if saveFileClose = True then
  begin

    msg := ' El archivo fue "MODIFICADO" ¿Desea guardar los cambios antes de salir?';
    TDialogService.MessageDialog(msg // mensaje del dialogo
      , TMsgDlgType.mtConfirmation // tipo de dialogo
      , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel] // botones
      , TMsgDlgBtn.mbNo // default button
      , 0 // help context
      ,
      procedure(const AResult: TModalResult)
      begin

        // CloseOk := (AResult = mrYES);
        if (AResult = mrYES) or (AResult = mrNO) then
        begin
          CloseOk := True;
        end

        else
        begin
          CloseOk := False;
        end;

        saveFileClose := False;

        case AResult of

          mrYES:
            begin

              memLog.Lines.SaveToFile(TPath.Combine(ruta, 'DialogosForm.txt'));
{$IFDEF ANDROID}
              ShowMessageToast(' SI SE GURADARON LOS CAMBIOS droid ', 10);
              Close;

{$ELSE}
              ShowMessage(' SI SE GURADARON LOS CAMBIOS win');

{$ENDIF}
            end;
          mrNO:
            begin
              memLog.Lines.LoadFromFile(TPath.Combine(ruta,
                'DialogosForm.txt'));
{$IFDEF ANDROID}
              ShowMessageToast(' NO SE GUARDARON LOS CAMBIOS droid ', 10);
              Close;

{$ELSE}
              ShowMessage('NO SE GUARDARON LOS CAMBIOS win');

{$ENDIF}
            end;
          mrCancel:
            saveFileClose := True;

        end;

      end);

  end
  else
    CloseOk := True;

  CanClose := CloseOk;

end;

procedure TfrmData.FormCreate(Sender: TObject);

begin

{$IF DEFINED(MSWINDOWS)}
  // windows
  ruta := '';
{$ELSEIF DEFINED(ANDROID)}
  // Android-specific code here

  ruta := TPath.GetDownloadsPath;
{$ENDIF}
  if FileExists(TPath.Combine(ruta, 'DialogosForm.txt')) = True then
    memLog.Lines.LoadFromFile(TPath.Combine(ruta, 'DialogosForm.txt'));
end;

procedure TfrmData.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    // guardar el texto en el memo y limpiarlo

    memLog.Lines.Add(edtData.Text);
    edtData.Text := '';
    saveFileClose := True;
  end;
end;

end.
