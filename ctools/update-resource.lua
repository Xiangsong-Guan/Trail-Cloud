-- 2018.10.13

os.execute("git clone https://github.com/xiangsong-guan/trail-cloud")
os.execute("rm -rf ../html")
os.execute("mv ./trail-cloud/html ../ ")
os.execute("rm -rf ./trail-cloud")

os.exit(0)
