package com.example.model;

// Model: タスクのデータを表すクラス
public class Task {
    private int id;              // タスクID
    private String title;        // タスク名
    // ステータス: "complete", "incomplete", "inprogress"
    private String status;       // タスク状態
    private String memo;         // メモ
    
    // コンストラクタ
    public Task() {
    }
    
    public Task(int id, String title, String status) {
        this.id = id;
        this.title = title;
        this.status = status != null ? status : "incomplete";
        this.memo = "";
    }
    
    // ゲッター
    public int getId() {
        return id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public String getStatus() {
        return status != null ? status : "incomplete";
    }
    
    public String getMemo() {
        return memo != null ? memo : "";
    }
    
    // セッター
    public void setId(int id) {
        this.id = id;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public void setCompleted(boolean completed) {
        this.status = completed ? "complete" : "incomplete";
    }
    
    public void setMemo(String memo) {
        this.memo = memo != null ? memo : "";
    }

    public void setStatus(String status) {
        this.status = status != null ? status : "incomplete";
    }
}