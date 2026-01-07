package com.example.util;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.example.model.Task;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import jakarta.servlet.ServletContext;

/**
 * タスクデータをJSONファイルに保存するユーティリティクラス
 */
public class TaskJsonExporter {
    
    // JSONファイルの出力先（プロジェクトルート直下）
    private static final String JSON_FILE_NAME = "tasks_data.json";
    private static ServletContext servletContext = null;
    
    /**
     * ServletContext を設定
     */
    public static void setServletContext(ServletContext context) {
        servletContext = context;
    }
    
    /**
     * JSONファイルのパスを取得
     */
    private static String getJsonFilePath() {
        // Eclipseのインストールディレクトリに保存
        return "C:\\pleiades\\2024-12\\eclipse\\tasks_data.json";
    }
    
    /**
     * JSONファイルからタスクリストを読み込み
     * @return 読み込まれたタスクリスト
     */
    public static List<Task> importTasksFromJson() {
        List<Task> taskList = new ArrayList<>();
        String filePath = getJsonFilePath();
        
        try {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(new FileReader(filePath));
            JSONArray jsonArray = (JSONArray) obj;
            
            for (Object taskObj : jsonArray) {
                JSONObject taskJson = (JSONObject) taskObj;
                int id = ((Long) taskJson.get("id")).intValue();
                String title = (String) taskJson.get("title");
                String status = (String) taskJson.get("status");
                String memo = (String) taskJson.get("memo");
                
                Task task = new Task(id, title, status);
                task.setMemo(memo != null ? memo : "");
                taskList.add(task);
            }
            
            System.out.println("[TaskJsonExporter] " + filePath + " から " + taskList.size() + " 件のタスクを読み込みました");
            
        } catch (IOException e) {
            System.err.println("[TaskJsonExporter] JSONファイル読み込みエラー（ファイルが見つかりません）: " + e.getMessage());
        } catch (ParseException e) {
            System.err.println("[TaskJsonExporter] JSONパースエラー: " + e.getMessage());
        }
        
        return taskList;
    }
    
    /**
     * タスクリストをJSONファイルに保存
     * @param taskList 保存するタスクリスト
     */
    public static void exportTasksToJson(List<Task> taskList) {
        if (taskList == null) {
            return;
        }
        
        String filePath = getJsonFilePath();
        
        try {
            // JSONArray を作成
            JSONArray jsonArray = new JSONArray();
            
            // 各タスクをJSONObject に変換
            for (Task task : taskList) {
                JSONObject taskJson = new JSONObject();
                taskJson.put("id", task.getId());
                taskJson.put("title", task.getTitle());
                taskJson.put("status", task.getStatus());
                taskJson.put("memo", task.getMemo());
                
                jsonArray.add(taskJson);
            }
            
            // JSONファイルに書き込み
            try (FileWriter fileWriter = new FileWriter(filePath)) {
                fileWriter.write(jsonArray.toJSONString());
                fileWriter.flush();
                System.out.println("[TaskJsonExporter] " + filePath + " に " + taskList.size() + " 件のタスクを保存しました");
            }
            
        } catch (IOException e) {
            System.err.println("[TaskJsonExporter] JSONファイル保存エラー: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
