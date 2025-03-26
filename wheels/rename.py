import os
import glob
import tempfile
import zipfile
import shutil

# 設定新的 package 名稱
new_package_name = "ta-lib-everywhere"

def modify_wheel(whl_path):
    # 建立暫存目錄
    with tempfile.TemporaryDirectory() as tmpdir:
        # 解壓 wheel
        with zipfile.ZipFile(whl_path, 'r') as zip_ref:
            zip_ref.extractall(tmpdir)

        # 找出 .dist-info 目錄
        dist_info_dirs = [d for d in os.listdir(tmpdir) if d.endswith('.dist-info')]
        if not dist_info_dirs:
            print(f"找不到 .dist-info 目錄：{whl_path}")
            return
        dist_info_dir = os.path.join(tmpdir, dist_info_dirs[0])
        metadata_path = os.path.join(dist_info_dir, "METADATA")
        if not os.path.exists(metadata_path):
            print(f"找不到 METADATA 檔案：{metadata_path}")
            return

        # 修改 METADATA 中的 Name 欄位
        with open(metadata_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
        new_lines = []
        for line in lines:
            if line.startswith("Name:"):
                new_lines.append(f"Name: {new_package_name}\n")
            else:
                new_lines.append(line)
        with open(metadata_path, "w", encoding="utf-8") as f:
            f.writelines(new_lines)

        # 依原有結構重新打包 wheel
        # 產生新檔名：將原始檔名中的 ta-lib 替換成 new_package_name，
        # 如不符合需求可自行調整命名邏輯
        dir_name, base_name = os.path.split(whl_path)
        new_base_name = base_name.replace("ta-lib", new_package_name).replace('ta_lib', new_package_name)
        new_whl_path = os.path.join(dir_name, new_base_name)
        with zipfile.ZipFile(new_whl_path, 'w', compression=zipfile.ZIP_DEFLATED) as zip_out:
            for root, dirs, files in os.walk(tmpdir):
                for file in files:
                    full_path = os.path.join(root, file)
                    # 使用相對路徑壓縮
                    arcname = os.path.relpath(full_path, tmpdir)
                    zip_out.write(full_path, arcname)
        print(f"已產生新的 wheel：{new_whl_path}")

def main():
    # 取得當前目錄下所有 .whl 檔案
    wheel_files = glob.glob("*.whl")
    if not wheel_files:
        print("找不到任何 .whl 檔案")
        return

    for whl in wheel_files:
        print(f"處理 {whl} ...")
        modify_wheel(whl)

if __name__ == "__main__":
    main()
