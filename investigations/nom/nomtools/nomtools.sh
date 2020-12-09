NOMPATH=/home/admin/src/sentiment-analysis-engine/investigations/nom
nom-go-build(){
  go build -o nom-go $NOMPATH/go/nom.go
}
nom-rust-build(){
  echo "https://doc.rust-lang.org/rustc/index.html"
  rustc -o nom-rs $NOMPATH/rust/nom.rs 
}
