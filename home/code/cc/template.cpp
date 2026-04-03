/*********
120j for solve()
*********/

#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef vector<long long> vll;
typedef pair<long long, long long> pll;

#define all(x) (x).begin(), (x).end()
#define rall(x) (x).rbegin(), (x).rend()

#define repeat(x) for (int repeater = 0; repeater < x; repeater++)
#define iterate(i, n) for (long long i = 1; i <= n; i++)
#define riterate(i, n) for (long long i = n; i > 0; i++)

vector<ll> in(int n) {
  ll temp;
  vector<ll> ret;
  repeat(n) {
    cin >> temp;
    ret.push_back(temp);
  }
  return ret;
}

template <class T> void out(T &container) {
  for (const T &element : container)
    cout << element << ' ';
  cout << endl;
}

template <typename T> void print(T item) { cout << item << endl; }

template <class T> void sortall(T &container) {
  sort(container.begin(), container.end());
}

template <class T> void rsortall(T &container) {
  sort(container.rbegin(), container.rend());
}

template <class T> T total(T &container) {
  return accumulate(container.first(), container.end(), 0LL);
}

template <typename T> T mod(T x) { return x % (static_cast<ll>(1e9) + 7); }

ll powmod(ll base, ll exp) {
  ll ret = 1;
  repeat(exp) {
    ret *= base;
    ret = ret % (static_cast<ll>(1e9) + 7);
  }
  return ret;
}

#define inf LONG_LONG_MAX;

ll factorial(ll x) {
  ll ret = 1;
  riterate(iter, x) ret *= iter;
  return ret;
}

ll nCr(ll n, ll r) {
  ll num = factorial(n);
  ll den = factorial(r) * factorial(n - r);
  return num / den;
}

ll nPr(ll n, ll r) {
  ll num = factorial(n);
  ll den = factorial(n - r);
  return num / den;
}

ll pow(ll base, ll exponent) {
  ll exp = exponent;
  ll b = base;
  ll result = 1;
  while (exp) {
    if (exp % 2)
      result *= b;
    b = b * b;
    exp /= 2;
  }
  return result;
}

ll pow(int base, int exponent) {
  ll exp = exponent;
  ll b = base;
  ll result = 1;
  while (exp) {
    if (exp % 2)
      result *= b;
    b = b * b;
    exp /= 2;
  }
  return result;
}

ll pow(ll base, int exponent) {
  ll exp = exponent;
  ll b = base;
  ll result = 1;
  while (exp) {
    if (exp % 2)
      result *= b;
    b = b * b;
    exp /= 2;
  }
  return result;
}

void solve() {
  // per test case code goes here
  // in(n) returns the input vector of size n
  
}

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  int t;
  cin >> t;
  while (t--) {
    solve();
  }
}
