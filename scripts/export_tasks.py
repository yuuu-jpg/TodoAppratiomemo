import json
import csv
from datetime import datetime
import os

def export_tasks_to_csv(json_file='../tasks_data.json', csv_file='tasks_report.csv'):
    """
    Javaアプリから出力されたJSONファイルを読み込んでCSVに出力
    
    Args:
        json_file: 読み込むJSONファイルパス（Javaアプリのプロジェクトルートのtasks_data.json）
        csv_file: 出力するCSVファイルパス
    """
    try:
        # JSONファイルの存在確認
        if not os.path.exists(json_file):
            print(f"⚠ {json_file} が見つかりません")
            print(f"  JavaアプリでタスクをJSONに保存してください")
            return False
        
        # JSONファイルを読み込む
        with open(json_file, 'r', encoding='utf-8') as f:
            tasks = json.load(f)
        
        if not isinstance(tasks, list):
            print(f"エラー: JSONファイルの形式が正しくありません")
            return False
        
        # CSVに出力
        with open(csv_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['ID', 'タイトル', 'ステータス', 'メモ'])
            
            for task in tasks:
                writer.writerow([
                    task.get('id', ''),
                    task.get('title', ''),
                    task.get('status', ''),
                    task.get('memo', '')
                ])
        
        print(f"✓ {len(tasks)}件のタスクを '{csv_file}' にエクスポートしました")
        print(f"✓ ファイルの場所: {os.path.abspath(csv_file)}")
        return True
        
    except FileNotFoundError:
        print(f"エラー: {json_file} が見つかりません")
        return False
    except json.JSONDecodeError:
        print(f"エラー: JSONファイルの解析に失敗しました")
        return False
    except Exception as e:
        print(f"エラー: {str(e)}")
        return False

if __name__ == '__main__':
    export_tasks_to_csv()
