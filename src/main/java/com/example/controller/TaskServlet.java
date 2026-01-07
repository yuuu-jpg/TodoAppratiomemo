package com.example.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.model.Task;
import com.example.util.TaskJsonExporter;

@WebServlet("/TaskServlet")
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        super.init();
        // ServletContext を TaskJsonExporter に設定
        TaskJsonExporter.setServletContext(this.getServletContext());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 文字エンコーディング設定
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        // セッション取得
        HttpSession session = request.getSession();
        
        // アクションパラメータ取得
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        // アクションに応じた処理
        switch (action) {
            case "setStatus":
                setStatus(request, session);
                break;
            case "delete":
                deleteTask(request, session);
                break;
            case "editMemo":
                // メモ編集画面へ遷移（リダイレクトしない）
                request.setAttribute("taskId", request.getParameter("id"));
                request.getRequestDispatcher("tasklist.jsp").forward(request, response);
                return;
            default:
                break;
        }
        
        // ホームページにリダイレクト
        response.sendRedirect("index.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 文字エンコーディング設定
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        // セッション取得
        HttpSession session = request.getSession();
        
        // メモ保存アクションか確認
        String action = request.getParameter("action");
        if ("saveMemo".equals(action)) {
            saveMemo(request, session);
            response.sendRedirect("index.jsp");
            return;
        }
        
        // タスク一覧をセッションから取得（なければ新規作成）
        @SuppressWarnings("unchecked")
        List<Task> taskList = (List<Task>) session.getAttribute("taskList");
        if (taskList == null) {
            taskList = new ArrayList<>();
        }
        
        // フォームからタスク名を取得
        String title = request.getParameter("title");
        
        // タスク名が入力されている場合のみ追加
        if (title != null && !title.trim().isEmpty()) {
            // 新しいIDを生成（既存の最大ID + 1）
            int newId = 1;
            for (Task task : taskList) {
                if (task.getId() >= newId) {
                    newId = task.getId() + 1;
                }
            }
            
            // 新しいタスクを作成して追加（デフォルトは未完了）
            Task newTask = new Task(newId, title.trim(), "incomplete");
            taskList.add(newTask);
            
            // セッションに保存
            session.setAttribute("taskList", taskList);
            
            // JSONファイルにエクスポート
            TaskJsonExporter.exportTasksToJson(taskList);
        }
        
        // ホームページにリダイレクト
        response.sendRedirect("index.jsp");
    }
    
    // タスクのステータスを設定
    private void setStatus(HttpServletRequest request, HttpSession session) {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        if (idStr != null && status != null) {
            try {
                int id = Integer.parseInt(idStr);

                @SuppressWarnings("unchecked")
                List<Task> taskList = (List<Task>) session.getAttribute("taskList");

                if (taskList != null) {
                    for (Task task : taskList) {
                        if (task.getId() == id) {
                            task.setStatus(status);
                            break;
                        }
                    }
                    session.setAttribute("taskList", taskList);
                    // JSONファイルにエクスポート
                    TaskJsonExporter.exportTasksToJson(taskList);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }
    
    // タスク削除
    private void deleteTask(HttpServletRequest request, HttpSession session) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                
                @SuppressWarnings("unchecked")
                List<Task> taskList = (List<Task>) session.getAttribute("taskList");
                
                if (taskList != null) {
                    // JSONファイルにエクスポート
                    TaskJsonExporter.exportTasksToJson(taskList);
                    taskList.removeIf(task -> task.getId() == id);
                    session.setAttribute("taskList", taskList);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    // メモ保存
    private void saveMemo(HttpServletRequest request, HttpSession session) {
        String idStr = request.getParameter("taskId");
        String memo = request.getParameter("memo");

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);

                @SuppressWarnings("unchecked")
                List<Task> taskList = (List<Task>) session.getAttribute("taskList");

                if (taskList != null) {
                    for (Task task : taskList) {
                        if (task.getId() == id) {
                            task.setMemo(memo != null ? memo : "");
                            break;
                        }
                    // JSONファイルにエクスポート
                    TaskJsonExporter.exportTasksToJson(taskList);
                    }
                    session.setAttribute("taskList", taskList);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

}
