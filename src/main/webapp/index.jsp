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
    <title>TODOアプリ</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        
        .subtitle {
            color: #666;
            font-size: 16px;
        }
        
        .form-section {
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
        
        input[type="text"] {
            width: 100%;
            padding: 15px;
            border: 1px solid #d0d0d0;
            border-radius: 1px;
            font-size: 16px;
            transition: border-color 0.2s;
            outline: none;
        }
        
        input[type="text"]:focus {
            border-color: #999;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 1px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #808080;
            color: white;
            width: 100%;
        }
        
        .btn-primary:hover {
            background: #696969;
        }
        
        .stats {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .chart-container {
            background: white;
            border-radius: 2px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 300px;
        }
        
        .chart-wrapper {
            width: 100%;
            max-width: 300px;
            height: 300px;
        }
        
        .task-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .task-item {
            background: white;
            border-radius: 1px;
            padding: 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: background-color 0.2s;
        }
        
        .task-item:hover {
            background-color: #fafafa;
        }
        
        .task-item.completed {
            opacity: 0.6;
        }
        
        .task-item.completed .task-title {
            text-decoration: line-through;
            color: #999;
        }
        
        .task-checkbox {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        
        .task-title {
            flex: 1;
            font-size: 18px;
            color: #333;
        }
        
        .task-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-delete {
            background: #f44336;
            color: white;
            padding: 8px 16px;
            border-radius: 1px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-delete:hover {
            background: #da190b;
        }
        
        .btn-memo {
            background: #2196F3;
            color: white;
            padding: 8px 16px;
            border-radius: 1px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-memo:hover {
            background: #1565C0;
        }
        
        .memo-preview {
            background: #f9f9f9;
            border-left: 3px solid #2196F3;
            padding: 10px;
            margin-top: 10px;
            border-radius: 1px;
            font-size: 13px;
            color: #555;
            max-height: 60px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: pre-wrap;
        }
        
        .status-buttons {
            display: flex;
            flex-direction: row;
            gap: 6px;
            align-items: center;
        }

        .status-btn {
            padding: 6px 8px;
            font-size: 13px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            display: inline-block;
        }

        .status-complete { background: #4CAF50; }
        .status-inprogress { background: #FFB300; }
        .status-incomplete { background: #808080; }

        /* ステータスを示す帯（タスク行） */
        .task-item.status-complete {
            border-left: 8px solid #4CAF50;
            background-color: #f1fbf1; /* 薄い緑 */
        }

        .task-item.status-inprogress {
            border-left: 8px solid #FFB300;
            background-color: #fffaf0; /* 薄い黄色 */
        }

        .task-item.status-incomplete {
            border-left: 8px solid #808080;
            background-color: #f6f6f6; /* 薄いグレー */
        }
        
        .empty-state {
            background: white;
            border-radius: 2px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
        
        .empty-state p {
            color: #666;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>TODOアプリ</h1>
            <p class="subtitle">タスク管理</p>
        </div>
        
        <div class="form-section">
            <form action="<%= request.getContextPath() %>/TaskServlet" method="post">
                <div class="form-group">
                    <label for="title">📝 新しいタスク名</label>
                    <input type="text" 
                           id="title" 
                           name="title" 
                           placeholder="例: 買い物に行く、レポートを書く..." 
                           required
                           autofocus>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    ➕ タスクを追加
                </button>
            </form>
        </div>
        
        <% 
            int totalTasks = (taskList != null) ? taskList.size() : 0;
            int completedTasks = 0;
            int inprogressTasks = 0;
            int incompleteTasks = 0;
            if (taskList != null) {
                for (Task task : taskList) {
                    String s = task.getStatus();
                    if ("complete".equals(s)) {
                        completedTasks++;
                    } else if ("inprogress".equals(s)) {
                        inprogressTasks++;
                    } else {
                        incompleteTasks++;
                    }
                }
            }
        %>
        
        <div class="chart-container">
            <% if (totalTasks > 0) { %>
                <div class="chart-wrapper">
                    <canvas id="taskChart"></canvas>
                </div>
            <% } else { %>
                <p style="color: #999; font-size: 16px;">タスクを追加すると、グラフが表示されます</p>
            <% } %>
        </div>
        
        <div class="task-list">
            <% 
                if (taskList == null || taskList.isEmpty()) {
            %>
                <div class="empty-state">
                    <p>📝 タスクがありません<br>上記のフォームから新しいタスクを追加してみましょう！</p>
                </div>
            <% 
                } else {
            %>
                <div style="background: white; border-radius: 2px; padding: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 12px;">
                    <div class="stats" style="text-align: center; font-size:14px;">
                        ✅ 完了: <%= completedTasks %> &nbsp; 🔄 進行中: <%= inprogressTasks %> &nbsp; 📋 未完了: <%= incompleteTasks %> &nbsp; / 全体: <%= totalTasks %>
                    </div>
                </div>
                
                <% 
                    for (Task task : taskList) {
                %>
                <div class="task-item status-<%= task.getStatus() %> <%= "complete".equals(task.getStatus()) ? "completed" : "" %>">
                    <div style="flex: 1; min-width:0;">
                        <div class="task-title"><%= task.getTitle() %></div>
                        <% if (task.getMemo() != null && !task.getMemo().isEmpty()) { %>
                            <div class="memo-preview">📌 <%= task.getMemo() %></div>
                        <% } %>
                    </div>
                    
                    <div class="task-actions">
                        <div class="status-buttons">
                            <a href="<%= request.getContextPath() %>/TaskServlet?action=setStatus&id=<%= task.getId() %>&status=complete" class="status-btn status-complete">完了</a>
                            <a href="<%= request.getContextPath() %>/TaskServlet?action=setStatus&id=<%= task.getId() %>&status=inprogress" class="status-btn status-inprogress">進行中</a>
                            <a href="<%= request.getContextPath() %>/TaskServlet?action=setStatus&id=<%= task.getId() %>&status=incomplete" class="status-btn status-incomplete">未完了</a>
                        </div>
                        <a href="<%= request.getContextPath() %>/TaskServlet?action=editMemo&id=<%= task.getId() %>" 
                            class="btn-memo">
                            📝 メモ
                        </a>
                        <a href="<%= request.getContextPath() %>/TaskServlet?action=delete&id=<%= task.getId() %>" 
                            class="btn-delete"
                            onclick="return confirm('このタスクを削除しますか？')">
                            削除
                        </a>
                    </div>
                </div>
                <% 
                    }
                %>
            <% 
                }
            %>
        </div>
    </div>
    
    <% if (totalTasks > 0) { %>
    <script>
        // タスク統計データを取得
        const totalTasks = <%= totalTasks %>;
        const completedTasks = <%= completedTasks %>;
        const inprogressTasks = <%= inprogressTasks %>;
        const incompleteTasks = <%= incompleteTasks %>;

        // Chart.jsで円グラフを描画（3セグメント）
        const ctx = document.getElementById('taskChart').getContext('2d');
        const taskChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['完了', '進行中', '未完了'],
                datasets: [{
                    data: [completedTasks, inprogressTasks, incompleteTasks],
                    backgroundColor: [
                        '#4CAF50', // 完了: 緑
                        '#FFB300', // 進行中: 黄
                        '#808080'  // 未完了: グレー
                    ],
                    borderColor: [
                        '#4CAF50',
                        '#FFB300',
                        '#808080'
                    ],
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            padding: 20,
                            usePointStyle: true
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed || 0;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                return label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>