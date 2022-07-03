unit Tel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DictionaryCollection, Menus;

Const
  DataFile='telephone.dat';  

type
  TTelephoneBook = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    NumberPanel: TPanel;
    Names: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel4: TPanel;
    Dictionary: TDictionary;
    Panel5: TPanel;
    Panel3: TPanel;
    Number: TEdit;
    PopupMenu1: TPopupMenu;
    SortbyName1: TMenuItem;
    SortByNumber1: TMenuItem;
    Shuffle1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure NamesClick(Sender: TObject);
    procedure NamesKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SortbyName1Click(Sender: TObject);
    procedure SortByNumber1Click(Sender: TObject);
    procedure Shuffle1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TelephoneBook: TTelephoneBook;

implementation

{$R *.dfm}

procedure TTelephoneBook.FormCreate(Sender: TObject);
begin
  Dictionary.LoadFromFile(DataFile);
  Names.Items.Assign(Dictionary.KeyList);
  Number.Align:=alClient;
end;

procedure TTelephoneBook.Button1Click(Sender: TObject);
Var
  Name,Number:String;
begin
  Name:=InputBox('Name:','First && Last name','');
  If Name='' Then Exit;
  Number:=InputBox('Number:','Telephone number','');
  If Number='' Then Exit;
  Dictionary.Value[Name]:=Number;
  Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.NamesClick(Sender: TObject);
begin
  Number.Text:=Dictionary.Value[Names.Items[Names.ItemIndex]];
end;

procedure TTelephoneBook.NamesKeyPress(Sender: TObject; var Key: Char);
begin
  NamesClick(Nil);
end;

procedure TTelephoneBook.Button2Click(Sender: TObject);
begin
  If Names.ItemIndex=-1 Then Exit;
  If Dictionary.Delete(Names.Items[Names.ItemIndex]) Then
    Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.Button3Click(Sender: TObject);
Var
  Name:String;
begin
  If Names.ItemIndex=-1 Then Exit;
  Name:=InputBox('Rename:','New name',Names.Items[Names.ItemIndex]);
  If Name='' Then Exit;
  If Dictionary.Rename(Names.Items[Names.ItemIndex],Name) Then
    Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.Button4Click(Sender: TObject);
Var
  Value:String;
begin
  If Names.ItemIndex=-1 Then Exit;
  Value:=InputBox('Number:','New number',Dictionary.Value[Names.Items[Names.ItemIndex]]);
  Dictionary.Value[Names.Items[Names.ItemIndex]]:=Value;
  Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.Button5Click(Sender: TObject);
begin
  Dictionary.Clear;
  Names.Items.Clear;
end;

procedure TTelephoneBook.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Dictionary.SaveToFile(DataFile);
end;

procedure TTelephoneBook.SortbyName1Click(Sender: TObject);
begin
  Dictionary.Sort(dsKey);
  Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.SortByNumber1Click(Sender: TObject);
begin
  Dictionary.Sort;
  Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.Shuffle1Click(Sender: TObject);
begin
  Dictionary.Sort(dsShuffle);
  Names.Items.Assign(Dictionary.KeyList);
end;

procedure TTelephoneBook.About1Click(Sender: TObject);
begin
  ShowMessage('Autor: Frank Hliva Copyright© 2004');
end;

end.
