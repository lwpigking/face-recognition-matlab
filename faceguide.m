function varargout = faceguide(varargin)
% FACEGUIDE MATLAB code for faceguide.fig
%      FACEGUIDE, by itself, creates a new FACEGUIDE or raises the existing
%      singleton*.
%
%      H = FACEGUIDE returns the handle to a new FACEGUIDE or the handle to
%      the existing singleton*.
%
%      FACEGUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEGUIDE.M with the given input arguments.
%
%      FACEGUIDE('Property','Value',...) creates a new FACEGUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before faceguide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to faceguide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help faceguide

% Last Modified by GUIDE v2.5 20-Dec-2024 14:00:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @faceguide_OpeningFcn, ...
                   'gui_OutputFcn',  @faceguide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before faceguide is made visible.
function faceguide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to faceguide (see VARARGIN)

% Choose default command line output for faceguide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes faceguide wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = faceguide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % 打开文件对话框选择图像文件
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files'}, 'Select an Image');
    
    % 如果用户选择了文件
    if isequal(file, 0)
        disp('User canceled file selection');
    else
        % 构造完整的文件路径
        imgPath = fullfile(path, file);
        
        % 读取图像
        img = imread(imgPath);
        
        % 将图像显示在 axes3 上
        axes(handles.axes3);
        imshow(img);
        title('选择的人脸');
        
        % 保存图像路径以便后续使用
        handles.imgPath = imgPath;
        guidata(hObject, handles);  % 更新 handles 结构
    end

% --- Executes on button press in pushbutton3.

function ImgData = imgdata()  
% 指定文件夹路径
folderPath = 'C:\\Users\\LENOVO\\Desktop\\face-recognition'; 

% 获取文件夹中所有 jpg 格式的图片
imageFiles = dir(fullfile(folderPath, '*.jpg'));
% 统计 jpg 图片的数量
global numImages;
numImages = length(imageFiles);
disp("一共有：" + numImages + "张人脸")

namud = 0.5;  

% 创建一个 cell 数组用于存储所有图片
pic_all = cell(1, numImages);  % 初始化一个 cell 数组来存储每张图片

for i = 1:numImages
    % 动态加载图片并进行预处理
    imgPath = i + ".jpg";
    pic_all{i} = rgb2gray(imread(imgPath));  % 读取图片并转换为灰度图
    pic_all{i} = imresize(pic_all{i}, namud);  % 调整图片大小
end

% 获取图片的尺寸

[m, n] = size(pic_all{1});  % 假设所有图片大小一致，获取第一个图片的尺寸
disp(m);
disp(n);
% 创建 ImgData 数组
% ImgData = zeros(numImages, m * n);  % 初始化一个大小为 numImages x (m*n) 的矩阵

% 将每张图片转换为一个行向量并存储在 ImgData 中
for i = 1:numImages
    ImgData(i, :) = reshape(pic_all{i}, 1, m * n);  % 将每张图片展开成一个行向量
end

% 将图片数据转换为 double 类型并归一化
ImgData = double(ImgData) / 255;  


function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 确保图像已加载
    % if isfield(handles, 'imgPath')
        imgPath = handles.imgPath;  % 获取之前加载的图像路径
        disp("选择的路径为" + imgPath)
        % img = imread(imgPath);       % 读取图像
        img=imgdata(); 
        % 对图像进行 PCA 处理
        % 假设 PCA 函数返回投影后的图像（或者是其他表示方式）
        Cell_ten = PCA(img, 2);  
        face1 = find(Cell_ten, imread(imgPath));  
        
        % 生成匹配图像的路径（假设是图像编号 + '.jpg'）
        match_img_path = strcat(num2str(face1), '.jpg');
        disp("匹配人脸路径: " + match_img_path);
        axes(handles.axes4)
        imshow(match_img_path);
        title('匹配后的人脸');
        % 显示 PCA 处理后的图像在 axes4 上
        % if exist(match_img_path, 'file')
            % matched_img = imread(match_img_path);
            % axes(handles.axes4);
            % imshow(matched_img);
            % title('PCA 处理后的图像');
        % else
            % msgbox('未找到匹配的图像', '错误', 'error');
        % end
    % else
        % msgbox('请先选择一张图片', '错误', 'error');
    % end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 获取默认摄像头
    vid = videoinput('winvideo', 1, 'YUY2_320x240');
    disp(vid);
    handles.vid = vid;
    guidata(hObject, handles);
    % 获取视频分辨率
    vidRes = get(vid, 'VideoResolution');
    nBands = get(vid, 'NumberOfBands');
    
    % 创建用于显示图像的句柄
    hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', handles.axes1);
    
    % 创建人脸检测器
    faceDetector = vision.CascadeObjectDetector();
    
    % 开始预览摄像头
    preview(vid, hImage);
    
    % 获取视频帧并进行人脸检测
    while true
        % 获取当前视频帧
        frame = getsnapshot(vid);
        
        % 将图像转换为灰度图（因为人脸检测器通常在灰度图像上工作）
        grayFrame = rgb2gray(frame);
        
        % 使用人脸检测器检测人脸
        bbox = step(faceDetector, grayFrame);  % bbox是一个N×4的矩阵，每行是一个检测到的人脸的位置 [x, y, width, height]
        
        % 在原图上绘制人脸框
        if ~isempty(bbox)
            % 清空当前绘制区域
            axes(handles.axes1);
            imshow(frame);
            hold on;
            
            % 绘制矩形框
            for i = 1:size(bbox, 1)
                rectangle('Position', bbox(i, :), 'EdgeColor', 'r', 'LineWidth', 1);
            end
            
            hold off;
        end
        
        % 更新显示
        drawnow;
    end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.vid,'ReturnedColorSpace','rgb');
frame = getsnapshot(handles.vid);
% frame = rgb2gray(frame);
% frame = imresize(frame, 0.5);
% frame = reshape(frame, 1, 90 * 75);
% frame = double(frame) / 255;

% img=imgdata(); 
% Cell_ten = PCA(img, 2);  
% face1 = find(Cell_ten, imread(frame));  
% match_img_path = strcat(num2str(face1), '.jpg');
% disp("匹配人脸路径: " + match_img_path);
axes(handles.axes5);
% imshow(match_img_path);
imshow(frame);
title('匹配后的人脸');

% 获取当前时间
current_time = datetime("now");
    
% 创建显示文本
display_text = ["lwpigking考勤成功，现在是" char(current_time)];
    
% 更新静态文本框显示的内容
set(handles.text8, 'String', display_text);
set(handles.text8, 'FontSize', 12);              

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % 如果 imgCounter 未定义，初始化为 11
 
 global imgCounter;
    if isempty(imgCounter)
        imgCounter = 11;
    end

    % 获取当前视频帧
    set(handles.vid,'ReturnedColorSpace','rgb');
    frame = getsnapshot(handles.vid);
    % frame = imresize(frame, [180, 150]);
    % 构造图片文件名
    filename = sprintf('C:\\Users\\LENOVO\\Desktop\\face-recognition\\%d.jpg', imgCounter);
    
    % 保存图片
    imwrite(frame, filename);
    
    % 输出保存的文件名
    disp(['保存图片: ', filename]);
    
    % 更新图片编号
    imgCounter = imgCounter + 1;
    f = msgbox("采集成功~！", "Success");


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = videoinput('winvideo', 1, 'YUY2_320x240');
disp(vid);
% 获取视频分辨率
vidRes = get(vid, 'VideoResolution');
nBands = get(vid, 'NumberOfBands');
% 创建用于显示图像的句柄
hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', handles.axes7);
% 开始预览摄像头
preview(vid, hImage);
handles.vid = vid;
guidata(hObject, handles);
