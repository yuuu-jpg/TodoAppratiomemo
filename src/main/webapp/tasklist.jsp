<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.Task" %>
<%@ page import="com.example.util.TaskJsonExporter" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<%
    // セッション初期化：初回ロード時にJSONファイルからタスクリストを読み込む
    List<Task> taskList = (List<Task>) session.getAttribute("taskList");
    
    if (taskList == null) {
        taskList = TaskJsonExporter.importTasksFromJson();
        session.setAttribute("taskList", taskList);
    }
%>
    <meta charset="UTF-8">
    <title>メモ編集 - TODOアプリ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f0f0f0 0%, #ffffff 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .container {
            max-width: 700px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            border-radius: 2px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .task-name {
            color: #2196F3;
            font-size: 24px;
            font-weight: 600;
            margin: 15px 0 10px 0;
        }
        
        .subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .memo-section {
            background: white;
            border-radius: 2px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #d0d0d0;
            border-radius: 1px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            resize: vertical;
            min-height: 250px;
            transition: border-color 0.2s;
            outline: none;
        }
        
        textarea:focus {
            border-color: #999;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 1px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-save {
            background: #4CAF50;
            color: white;
        }
        
        .btn-save:hover {
            background: #45a049;
        }
        
        .btn-back {
            background: #808080;
            color: white;
        }
        
        .btn-back:hover {
            background: #696969;
        }
        
        .info-box {
            background: #f0f0f0;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 1px;
            margin-top: 20px;
        }
        
        .info-box p {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <% 
        String taskIdStr = request.getParameter("id");
        int taskId = -1;
        Task currentTask = null;
        
        if (taskIdStr != null) {
            try {
                taskId = Integer.parseInt(taskIdStr);
                taskList = (List<Task>) session.getAttribute("taskList");
                if (taskList != null) {
                    for (Task task : taskList) {
                        if (task.getId() == taskId) {
                            currentTask = task;
                            break;
                        }
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    %>
    
    <div class="container">
        <div class="header">
            <h1>📝 メモ編集</h1>
            <% if (currentTask != null) { %>
                <p class="task-name"><%= currentTask.getTitle() %></p>
            <% } %>
            <p class="subtitle">このタスクの進捗やメモを記入してください</p>
        </div>
        
        <% if (currentTask != null) { %>
        <div class="memo-section">
            <form method="post" action="<%= request.getContextPath() %>/TaskServlet">
                <input type="hidden" name="action" value="saveMemo">
                <input type="hidden" name="taskId" value="<%= taskId %>">
                
                <div class="form-group">
                    <label for="memo">メモ内容</label>
                    <textarea id="memo" name="memo" placeholder="このタスクの進捗状況、やることリスト、気づいたことなど..."><%= currentTask.getMemo() %></textarea>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-save">
                        💾 メモを保存
                    </button>
                    <a href="index.jsp" class="btn btn-back">
                        ← タスク一覧に戻る
                    </a>
                </div>
            </form>
            
            <div class="info-box">
                <p>
                    <strong>💡 ヒント:</strong> メモは自動的に保存されます。
                    「メモを保存」ボタンをクリックするとタスク一覧に戻ります。
                </p>
            </div>
        </div>
        <% } else { %>
        <div class="memo-section">
            <p style="color: #999; text-align: center; padding: 20px;">
                タスクが見つかりません。<br>
                <a href="index.jsp">タスク一覧に戻る</a>
            </p>
        </div>
        <% } %>
    </div>
</body>
</html>