# Simple Social Platform
簡易社群媒體平台，使用 Vue 3、Spring Boot、MySQL 與 Nginx。
## 啟動方式
請先確認 Docker Desktop 已啟動，然後在專案根目錄執行：

```powershell
docker compose up --build
```
第一次啟動會下載並建立 Nginx、Vue 前端、Spring Boot 後端與 MySQL 資料庫容器。資料庫會自動執行 `DB/01_schema.sql` 建立資料表與 Stored Procedures，並執行 `DB/02_sample_data.sql` 建立範例資料。
完成後開啟 [http://localhost](http://localhost)。
停止服務時，先按 `Ctrl + C`，再執行：
```powershell
docker compose down
## 系統架構

```text
Browser → Nginx Web Server → Spring Boot Application Server → MySQL Database
```

- `nginx/`：Web Server 設定與 Vue 靜態檔服務。
- `backend/.../api/`：展示層（REST Controller）。
- `backend/.../service/`：業務層與交易控制。
- `backend/.../data/`：資料層與 Stored Procedure 呼叫。
- `backend/.../common/`、`security/`：共用層、JWT 驗證與例外處理。
- `DB/`：MySQL DDL、DML 與 Stored Procedures。
