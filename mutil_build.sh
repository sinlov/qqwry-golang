#!/usr/bin/env bash

buildPath="build"
repoPath="repo"
ReNameCode="qiniu_upload"
VERSION_MAJOR=1
VERSION_MINOR=0
VERSION_PATCH=0
VERSION_BUILD=0

build_file="main.go"
bit_support=(amd64)
#bit_support=(amd64 386)
#build_platform=(darwin)
build_platform=(darwin linux windows)
#build_platform[0]=plugintemp

VersionCode=$[$[VERSION_MAJOR * 100000000] + $[VERSION_MINOR * 100000] + $[VERSION_PATCH * 100] + $[VERSION_BUILD]]
VersionName="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.${VERSION_BUILD}"
RepoFileName="${ReNameCode}_${VersionName}"

shell_running_path=$(cd `dirname $0`; pwd)
work_path=$0

checkFuncBack(){
  if [ $? -eq 0 ]; then
    echo -e "\033[;30mRun [ $1 ] success\033[0m"
  else
    echo -e "\033[;31mRun [ $1 ] error exit code 1\033[0m"
    exit 1
  fi
}

checkEnv(){
  evn_checker=`which $1`
  checkFuncBack "which $1"
  if [ ! -n "evn_checker" ]; then
    echo -e "\033[;31mCheck event [ $1 ] error exit\033[0m"
    exit 1
  else
    echo -e "\033[;32mCli [ $1 ] event check success\033[0m\n-> \033[;34m$1 at Path: ${evn_checker}\033[0m"
  fi
}

if [ -d "${buildPath}" ]; then
    rm -rf ${buildPath}
    sleep 1
fi

echo -e "============\n\033[;34mPrint build info start\033[0m"
go version
which go
echo -e "Your settings is
\tVersion Name -> ${ReNameCode}
\tVersion code -> ${VersionCode}
\tVersion name -> ${VersionName}
\tPackage rename -> ${RepoFileName}
\tBuild Path -> ${work_path}/${buildPath}
"
echo -e "\033[;34mPrint build info end\033[0m\n============"

mkdir -p ${buildPath}

for platform in ${build_platform[@]};
do
    for bit in ${bit_support[@]};
    do
      echo "start build platform: ${platform}-${bit}"
      CGO_ENABLED=0 GOOS=${platform} GOARCH=${bit} go build -o "main" ${build_file}
      if [ "windows" == "${platform}" ]; then
        mv "main" "${buildPath}/${RepoFileName}_${platform}_${bit}.exe"
      else
        mv "main" "${buildPath}/${RepoFileName}_${platform}_${bit}"
      fi
      echo "build OSX 64 finish"
      done
    done

want_repo="n"
read -p "Do you want repo:(y/or nothing is not need)? " want_repo
if [ "y" == "${want_repo}" ]; then
  out_folder=${VERSION_MAJOR}-${VERSION_MINOR}-${VERSION_PATCH}
  out_tar_name="${ReNameCode}-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.tag.gz"
  out_folder_path="${repoPath}/${ReNameCode}/${out_folder}/"
  out_tar_path="${repoPath}/${ReNameCode}/${out_tar_name}"
  mkdir -p "${out_folder_path}"
  cp -r "${buildPath}/" "${out_folder_path}"
  echo -e "Repo config
\tRepo path: ${out_folder_path}
\tRepo out_tar_path: ${out_tar_path}
"
cd ${repoPath}
tar zcvf "${ReNameCode}/${out_tar_name}" "${ReNameCode}/${out_folder}"
cd ${shell_running_path}
rm -rf ${out_folder_path}
sleep 1

echo -e "=>Out repo tar \033[;36m-> ${out_tar_path}\033[0m"
else
  echo -e "=>\033[;36mBuild success -> ${work_path}/${buildPath}\033[0m"
fi
